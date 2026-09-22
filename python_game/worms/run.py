# Version: 2.1.0
# Full Object-Oriented Worms prototype with 360-degree arrow aiming and game state management.

import math
import sys
import pygame

# Initialize Pygame
pygame.init()
WIDTH, HEIGHT = 1000, 600

# Colors
SKY_BLUE = (135, 206, 235)
DIRT_BROWN = (139, 69, 19)
RED = (220, 20, 60)
BLACK = (20, 20, 20)
WHITE = (255, 255, 255)
GOLD = (255, 215, 0)
DARK_GRAY = (50, 50, 50)


class Terrain:
    """Handles destructible terrain surface and mask collisions."""

    def __init__(self, width, height):
        self.width = width
        self.height = height
        self.surface = pygame.Surface((width, height), pygame.SRCALPHA)
        self.reset()

    def reset(self):
        self.surface.fill((0, 0, 0, 0))
        pygame.draw.ellipse(self.surface, DIRT_BROWN, (-100, 320, 1200, 380))

    def destroy(self, x, y, radius):
        pygame.draw.circle(self.surface, (0, 0, 0, 0),
                           (int(x), int(y)), radius)

    def is_solid(self, x, y):
        if 0 <= x < self.width and 0 <= y < self.height:
            return self.surface.get_at((int(x), int(y))).a > 0
        return False

    def draw(self, screen):
        screen.blit(self.surface, (0, 0))


class Worm:
    """Represents a player unit with aiming, charging, and firing capabilities."""

    def __init__(self, x, y, color=RED):
        self.pos = [float(x), float(y)]
        self.color = color
        self.radius = 10
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
        vy = -speed * math.sin(rad)  # Invert Y for Pygame coordinate space
        projectile = ArrowProjectile(self.pos[0], self.pos[1], vx, vy)
        self.power = 0.0
        self.charging = False
        return projectile

    def draw(self, screen, bounce_timer):
        # Draw Worm body
        pygame.draw.circle(
            screen,
            self.color,
            (int(self.pos[0]), int(self.pos[1])),
            self.radius,
        )

        # Draw floating turn indicator arrow
        hover_y = self.pos[1] - 30 + math.sin(bounce_timer) * 4
        self._draw_arrow(
            screen, GOLD, (self.pos[0], hover_y - 15), math.pi / 2, length=15
        )

        # Draw 360 aim vector line
        rad = math.radians(self.aim_angle)
        line_len = 30 + self.power * 0.3
        end_x = self.pos[0] + line_len * math.cos(rad)
        end_y = self.pos[1] - line_len * math.sin(rad)
        pygame.draw.line(screen, WHITE, self.pos, (end_x, end_y), 2)

    @staticmethod
    def _draw_arrow(surface, color, start_pos, angle_rad, length=24):
        """Helper utility to draw oriented vector arrows."""
        end_x = start_pos[0] + length * math.cos(angle_rad)
        end_y = start_pos[1] + length * math.sin(angle_rad)

        pygame.draw.line(surface, color, start_pos, (end_x, end_y), 3)

        head_size = 7
        left_wing_x = end_x - head_size * math.cos(angle_rad - math.pi / 6)
        left_wing_y = end_y - head_size * math.sin(angle_rad - math.pi / 6)
        right_wing_x = end_x - head_size * math.cos(angle_rad + math.pi / 6)
        right_wing_y = end_y - head_size * math.sin(angle_rad + math.pi / 6)

        pygame.draw.polygon(
            surface,
            color,
            [
                (end_x, end_y),
                (left_wing_x, left_wing_y),
                (right_wing_x, right_wing_y),
            ],
        )


class ArrowProjectile:
    """Handles flight trajectory, gravity physics, and terrain destruction."""

    def __init__(self, x, y, vx, vy):
        self.pos = [float(x), float(y)]
        self.vel = [float(vx), float(vy)]
        self.active = True
        self.gravity = 500.0

    def update(self, dt, terrain):
        if not self.active:
            return

        self.vel[1] += self.gravity * dt
        self.pos[0] += self.vel[0] * dt
        self.pos[1] += self.vel[1] * dt

        px, py = int(self.pos[0]), int(self.pos[1])

        if 0 <= px < terrain.width and 0 <= py < terrain.height:
            if terrain.is_solid(px, py):
                terrain.destroy(px, py, 35)
                self.active = False
        else:
            if py >= terrain.height or px < 0 or px >= terrain.width:
                self.active = False

    def draw(self, screen):
        if not self.active:
            return
        flight_angle = math.atan2(self.vel[1], self.vel[0])
        Worm._draw_arrow(screen, BLACK, self.pos, flight_angle, length=20)


class Game:
    """Main game controller managing loops, input events, and rendering states."""

    def __init__(self):
        self.screen = pygame.display.set_mode((WIDTH, HEIGHT))
        pygame.display.set_caption("Worms Prototype - OOP Edition")
        self.clock = pygame.time.Clock()
        self.font_title = pygame.font.SysFont("Arial", 48, bold=True)
        self.font_ui = pygame.font.SysFont("Arial", 22)

        self.state = "MENU"
        self.terrain = Terrain(WIDTH, HEIGHT)
        self.worm = Worm(200, 270)
        self.projectile = None
        self.bounce_timer = 0.0

        self.start_btn = pygame.Rect(WIDTH // 2 - 100, HEIGHT // 2, 200, 50)

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
                if (
                    self.state == "MENU"
                    and self.start_btn.collidepoint(event.pos)
                ):
                    self.terrain.reset()
                    self.worm = Worm(200, 270)
                    self.projectile = None
                    self.state = "PLAYING"

        return True

    def update(self, dt):
        if self.state != "PLAYING":
            return

        keys = pygame.key.get_pressed()

        if keys[pygame.K_ESCAPE]:
            self.state = "MENU"

        # 360-Degree Aiming controls
        if keys[pygame.K_LEFT]:
            self.worm.update_aim(120.0, dt)
        if keys[pygame.K_RIGHT]:
            self.worm.update_aim(-120.0, dt)

        # Spacebar power charging
        if keys[pygame.K_SPACE] and not self.projectile:
            self.worm.charging = True
            self.worm.update_charge(dt)
        elif self.worm.charging:
            self.projectile = self.worm.fire()

        # Update active projectile
        if self.projectile:
            self.projectile.update(dt, self.terrain)
            if not self.projectile.active:
                self.projectile = None

    def render(self):
        self.screen.fill(SKY_BLUE)

        if self.state == "MENU":
            self.render_menu()
        elif self.state == "PLAYING":
            self.render_game()

        pygame.display.flip()

    def render_menu(self):
        title = self.font_title.render("WORMS: OOP EDITION", True, BLACK)
        self.screen.blit(title, (WIDTH // 2 - title.get_width() // 2, 120))

        mouse_pos = pygame.mouse.get_pos()
        btn_color = GOLD if self.start_btn.collidepoint(mouse_pos) else WHITE
        pygame.draw.rect(self.screen, btn_color,
                         self.start_btn, border_radius=8)
        pygame.draw.rect(
            self.screen, DARK_GRAY, self.start_btn, width=2, border_radius=8
        )

        btn_txt = self.font_ui.render("START GAME", True, BLACK)
        self.screen.blit(
            btn_txt,
            (
                self.start_btn.centerx - btn_txt.get_width() // 2,
                self.start_btn.centery - btn_txt.get_height() // 2,
            ),
        )

        info_lines = [
            "Controls:",
            "- Left/Right Arrows: 360° Aim Angle",
            "- Hold Spacebar: Charge Power",
            "- ESC: Back to Menu",
        ]
        for idx, line in enumerate(info_lines):
            info_txt = self.font_ui.render(line, True, DARK_GRAY)
            self.screen.blit(
                info_txt, (WIDTH // 2 - 140, HEIGHT // 2 + 80 + idx * 28)
            )

    def render_game(self):
        self.terrain.draw(self.screen)
        self.worm.draw(self.screen, self.bounce_timer)

        if self.projectile:
            self.projectile.draw(self.screen)

        hud = self.font_ui.render(
            f"Power: {int(self.worm.power)}%  |  Angle: {int(self.worm.aim_angle)}°",
            True,
            BLACK,
        )
        self.screen.blit(hud, (20, 20))


if __name__ == "__main__":
    game = Game()
    game.run()
