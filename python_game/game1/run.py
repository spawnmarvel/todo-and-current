# Version: 3.0.0
# Capy-Barrage: A cozy Capybara-themed turn-based artillery game built with Pygame.

import math
import sys
import pygame

# Initialize Pygame
pygame.init()
WIDTH, HEIGHT = 1000, 600

# Cozy Color Palette
SKY_BLUE = (176, 224, 230)
SNOW_WHITE = (245, 248, 250)
DIRT_BROWN = (120, 82, 53)
CAPY_BROWN = (160, 110, 70)
CAPY_DARK = (100, 65, 40)
YUZU_ORANGE = (255, 165, 0)
YUZU_YELLOW = (255, 215, 0)
HEALTH_GREEN = (76, 175, 80)
BLACK = (20, 20, 20)
WHITE = (255, 255, 255)
DARK_GRAY = (60, 60, 60)


class Terrain:
    """Handles the cozy snow-covered mountain and onsen terrain."""

    def __init__(self, width, height):
        self.width = width
        self.height = height
        self.surface = pygame.Surface((width, height), pygame.SRCALPHA)
        self.reset()

    def reset(self):
        self.surface.fill((0, 0, 0, 0))
        # Dirt base layer
        pygame.draw.ellipse(self.surface, DIRT_BROWN, (-100, 320, 1200, 380))
        # Soft snow top cap
        pygame.draw.ellipse(self.surface, SNOW_WHITE, (-80, 310, 1160, 200))

    def destroy(self, x, y, radius):
        pygame.draw.circle(self.surface, (0, 0, 0, 0),
                           (int(x), int(y)), radius)

    def is_solid(self, x, y):
        if 0 <= x < self.width and 0 <= y < self.height:
            return self.surface.get_at((int(x), int(y))).a > 0
        return False

    def draw(self, screen):
        screen.blit(self.surface, (0, 0))


class Capybara:
    """Represents a chill, unbothered Capybara player unit."""

    def __init__(self, x, y, team_name, team_color):
        self.pos = [float(x), float(y)]
        self.team_name = team_name
        self.team_color = team_color
        self.radius = 16
        self.hp = 100
        self.max_hp = 100
        self.aim_angle = 45.0  # degrees (0 to 360)
        self.power = 0.0
        self.charging = False

    def update_aim(self, change, dt):
        self.aim_angle = (self.aim_angle + change * dt) % 360.0

    def update_charge(self, dt):
        if self.charging:
            self.power = min(100.0, self.power + 50.0 * dt)

    def fire(self):
        rad = math.radians(self.aim_angle)
        speed = self.power * 12.0
        vx = speed * math.cos(rad)
        vy = -speed * math.sin(rad)
        projectile = YuzuMortar(self.pos[0], self.pos[1] - 10, vx, vy)
        self.power = 0.0
        self.charging = False
        return projectile

    def draw(self, screen, is_active, bounce_timer):
        cx, cy = int(self.pos[0]), int(self.pos[1])

        # Draw Capybara Body (Relaxed potato shape)
        pygame.draw.ellipse(screen, CAPY_BROWN, (cx - 18, cy - 12, 36, 24))
        # Capybara Snout
        pygame.draw.ellipse(screen, CAPY_DARK, (cx + 8, cy - 8, 12, 14))

        # Yuzu fruit resting on head
        pygame.draw.circle(screen, YUZU_YELLOW, (cx, cy - 15), 5)
        pygame.draw.circle(screen, (34, 139, 34), (cx, cy - 19), 2)  # Leaf

        # Team Indicator Ring
        pygame.draw.circle(screen, self.team_color, (cx, cy), 18, width=2)

        # Health Bar
        bar_w = 32
        bar_h = 5
        fill_w = int((self.hp / self.max_hp) * bar_w)
        pygame.draw.rect(
            screen, DARK_GRAY, (cx - bar_w // 2, cy - 28, bar_w, bar_h)
        )
        pygame.draw.rect(
            screen, HEALTH_GREEN, (cx - bar_w // 2, cy - 28, fill_w, bar_h)
        )

        # Floating Arrow for active Capybara
        if is_active:
            hover_y = cy - 42 + math.sin(bounce_timer) * 4
            pygame.draw.polygon(
                screen,
                YUZU_ORANGE,
                [
                    (cx, hover_y),
                    (cx - 6, hover_y - 10),
                    (cx + 6, hover_y - 10),
                ],
            )

            # 360° Aiming Line
            rad = math.radians(self.aim_angle)
            line_len = 35 + self.power * 0.3
            end_x = self.pos[0] + line_len * math.cos(rad)
            end_y = self.pos[1] - line_len * math.sin(rad)
            pygame.draw.line(screen, WHITE, (cx, cy), (end_x, end_y), 2)


class YuzuMortar:
    """A cozy floating yuzu fruit projectile that carves out craters on impact."""

    def __init__(self, x, y, vx, vy):
        self.pos = [float(x), float(y)]
        self.vel = [float(vx), float(vy)]
        self.active = True
        self.gravity = 480.0

    def update(self, dt, terrain, capybaras):
        if not self.active:
            return

        self.vel[1] += self.gravity * dt
        self.pos[0] += self.vel[0] * dt
        self.pos[1] += self.vel[1] * dt

        px, py = int(self.pos[0]), int(self.pos[1])

        # Check collision with terrain
        if 0 <= px < terrain.width and 0 <= py < terrain.height:
            if terrain.is_solid(px, py):
                self.explode(terrain, capybaras)
                return
        else:
            if py >= terrain.height or px < 0 or px >= terrain.width:
                self.active = False

    def explode(self, terrain, capybaras):
        terrain.destroy(self.pos[0], self.pos[1], 40)
        # Apply splash damage to nearby Capybaras
        for capy in capybaras:
            dist = math.hypot(capy.pos[0] - self.pos[0],
                              capy.pos[1] - self.pos[1])
            if dist < 45:
                capy.hp = max(0, capy.hp - int(35 * (1 - dist / 45)))
        self.active = False

    def draw(self, screen):
        if not self.active:
            return
        cx, cy = int(self.pos[0]), int(self.pos[1])
        pygame.draw.circle(screen, YUZU_YELLOW, (cx, cy), 6)
        pygame.draw.circle(screen, YUZU_ORANGE, (cx, cy), 6, width=1)


class Game:
    """Main game controller for Capy-Barrage."""

    def __init__(self):
        self.screen = pygame.display.set_mode((WIDTH, HEIGHT))
        pygame.display.set_caption("Capy-Barrage: Onsen Warfare")
        self.clock = pygame.time.Clock()
        self.font_title = pygame.font.SysFont("Arial", 44, bold=True)
        self.font_ui = pygame.font.SysFont("Arial", 20, bold=True)

        self.state = "MENU"
        self.terrain = Terrain(WIDTH, HEIGHT)
        self.capybaras = []
        self.active_index = 0
        self.projectile = None
        self.bounce_timer = 0.0
        self.turn_timer = 30.0

        self.start_btn = pygame.Rect(WIDTH // 2 - 110, HEIGHT // 2, 220, 50)

    def reset_game(self):
        self.terrain.reset()
        self.capybaras = [
            Capybara(220, 270, "Team Orange", YUZU_ORANGE),
            Capybara(780, 270, "Team Yuzu", YUZU_YELLOW),
        ]
        self.active_index = 0
        self.projectile = None
        self.turn_timer = 30.0

    def next_turn(self):
        self.active_index = (self.active_index + 1) % len(self.capybaras)
        self.turn_timer = 30.0

    def run(self):
        running = True
        while running:
            dt = self.clock.tick(60) / 1000.0
            self.bounce_timer += dt * 5

            running = self.handle_events()
            self.update(dt)
            self.render()

        pygame.quit()
        sys.exit()

    def handle_events(self):
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                return False

            if event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
                if self.state == "MENU" and self.start_btn.collidepoint(
                    event.pos
                ):
                    self.reset_game()
                    self.state = "PLAYING"

        return True

    def update(self, dt):
        if self.state != "PLAYING":
            return

        active_capy = self.capybaras[self.active_index]
        keys = pygame.key.get_pressed()

        if keys[pygame.K_ESCAPE]:
            self.state = "MENU"

        # Update turn clock
        if not self.projectile:
            self.turn_timer -= dt
            if self.turn_timer <= 0:
                self.next_turn()
                return

        # Aiming controls
        if keys[pygame.K_LEFT]:
            active_capy.update_aim(120.0, dt)
        if keys[pygame.K_RIGHT]:
            active_capy.update_aim(-120.0, dt)

        # Power charging
        if keys[pygame.K_SPACE] and not self.projectile:
            active_capy.charging = True
            active_capy.update_charge(dt)
        elif active_capy.charging:
            self.projectile = active_capy.fire()

        # Update Projectile
        if self.projectile:
            self.projectile.update(dt, self.terrain, self.capybaras)
            if not self.projectile.active:
                self.projectile = None
                self.next_turn()

    def render(self):
        self.screen.fill(SKY_BLUE)

        if self.state == "MENU":
            self.render_menu()
        elif self.state == "PLAYING":
            self.render_game()

        pygame.display.flip()

    def render_menu(self):
        title = self.font_title.render("CAPY-BARRAGE", True, CAPY_DARK)
        subtitle = self.font_ui.render("Cozy Onsen Warfare", True, DARK_GRAY)
        self.screen.blit(title, (WIDTH // 2 - title.get_width() // 2, 110))
        self.screen.blit(
            subtitle, (WIDTH // 2 - subtitle.get_width() // 2, 165)
        )

        mouse_pos = pygame.mouse.get_pos()
        btn_color = (
            YUZU_YELLOW if self.start_btn.collidepoint(mouse_pos) else WHITE
        )
        pygame.draw.rect(self.screen, btn_color,
                         self.start_btn, border_radius=10)
        pygame.draw.rect(
            self.screen, CAPY_DARK, self.start_btn, width=2, border_radius=10
        )

        btn_txt = self.font_ui.render("START BATTLE", True, BLACK)
        self.screen.blit(
            btn_txt,
            (
                self.start_btn.centerx - btn_txt.get_width() // 2,
                self.start_btn.centery - btn_txt.get_height() // 2,
            ),
        )

    def render_game(self):
        self.terrain.draw(self.screen)

        active_capy = self.capybaras[self.active_index]
        for idx, capy in enumerate(self.capybaras):
            capy.draw(self.screen, idx == self.active_index, self.bounce_timer)

        if self.projectile:
            self.projectile.draw(self.screen)

        # HUD Overlay
        hud_team = self.font_ui.render(
            f"Turn: {active_capy.team_name}", True, active_capy.team_color
        )
        hud_info = self.font_ui.render(
            f"Power: {int(active_capy.power)}% | Angle: {int(active_capy.aim_angle)}° | Time: {int(self.turn_timer)}s",
            True,
            BLACK,
        )
        self.screen.blit(hud_team, (20, 20))
        self.screen.blit(hud_info, (20, 48))


if __name__ == "__main__":
    game = Game()
    game.run()
