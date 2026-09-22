# Version: 1.2.0
# Extended aim angle targeting to full 360-degree range.

import math
import sys
import pygame

# Initialize Pygame
pygame.init()
WIDTH, HEIGHT = 1000, 600
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Worms Prototype")
clock = pygame.time.Clock()

# Fonts
font_title = pygame.font.SysFont("Arial", 48, bold=True)
font_ui = pygame.font.SysFont("Arial", 22)

# Colors
SKY_BLUE = (135, 206, 235)
DIRT_BROWN = (139, 69, 19)
RED = (220, 20, 60)
BLACK = (20, 20, 20)
WHITE = (255, 255, 255)
GOLD = (255, 215, 0)
DARK_GRAY = (50, 50, 50)


def destroy_terrain(surface, x, y, radius):
    """Carves a circular hole out of the terrain surface."""
    pygame.draw.circle(surface, (0, 0, 0, 0), (int(x), int(y)), radius)


def create_terrain():
    """Generates the initial destructible land mass."""
    surf = pygame.Surface((WIDTH, HEIGHT), pygame.SRCALPHA)
    surf.fill((0, 0, 0, 0))
    pygame.draw.ellipse(surf, DIRT_BROWN, (-100, 320, 1200, 380))
    return surf


def draw_arrow(surface, color, start_pos, angle_rad, length=24):
    """Draws an arrow shape given a position and direction vector angle."""
    end_x = start_pos[0] + length * math.cos(angle_rad)
    end_y = start_pos[1] + length * math.sin(angle_rad)

    # Main shaft
    pygame.draw.line(surface, color, start_pos, (end_x, end_y), 3)

    # Arrowhead wings
    head_size = 7
    left_wing_x = end_x - head_size * math.cos(angle_rad - math.pi / 6)
    left_wing_y = end_y - head_size * math.sin(angle_rad - math.pi / 6)
    right_wing_x = end_x - head_size * math.cos(angle_rad + math.pi / 6)
    right_wing_y = end_y - head_size * math.sin(angle_rad + math.pi / 6)

    pygame.draw.polygon(
        surface,
        color,
        [(end_x, end_y), (left_wing_x, left_wing_y), (right_wing_x, right_wing_y)],
    )


# Game States
STATE_MENU = "MENU"
STATE_PLAYING = "PLAYING"
game_state = STATE_MENU

# Entities & World Data
terrain = create_terrain()
worm_pos = [200, 270]
aim_angle = 45.0  # degrees (0 to 360)
power = 0.0
charging = False
projectile = None  # Format: [x, y, vx, vy]
bounce_timer = 0.0

# UI Buttons
start_button_rect = pygame.Rect(WIDTH // 2 - 100, HEIGHT // 2, 200, 50)

running = True
while running:
    dt = clock.tick(60) / 1000.0  # Delta time
    bounce_timer += dt * 5

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

        if event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
            if (
                game_state == STATE_MENU
                and start_button_rect.collidepoint(event.pos)
            ):
                # Start / Reset Game
                terrain = create_terrain()
                worm_pos = [200, 270]
                aim_angle = 45.0
                power = 0.0
                charging = False
                projectile = None
                game_state = STATE_PLAYING

    keys = pygame.key.get_pressed()

    if game_state == STATE_MENU:
        # Render Menu
        screen.fill(SKY_BLUE)

        # Title
        title_txt = font_title.render("WORMS: ARROW EDITION", True, BLACK)
        screen.blit(
            title_txt, (WIDTH // 2 - title_txt.get_width() // 2, 120)
        )

        # Start Button
        mouse_pos = pygame.mouse.get_pos()
        btn_color = GOLD if start_button_rect.collidepoint(
            mouse_pos) else WHITE
        pygame.draw.rect(screen, btn_color, start_button_rect, border_radius=8)
        pygame.draw.rect(
            screen, DARK_GRAY, start_button_rect, width=2, border_radius=8
        )

        btn_txt = font_ui.render("START GAME", True, BLACK)
        screen.blit(
            btn_txt,
            (
                start_button_rect.centerx - btn_txt.get_width() // 2,
                start_button_rect.centery - btn_txt.get_height() // 2,
            ),
        )

        # Controls Instructions
        info_lines = [
            "Controls:",
            "- Left/Right Arrows: 360° Aim Angle Adjustment",
            "- Hold Spacebar: Charge Shot Power",
            "- Press ESC: Return to Menu",
        ]
        for idx, line in enumerate(info_lines):
            info_txt = font_ui.render(line, True, DARK_GRAY)
            screen.blit(info_txt, (WIDTH // 2 - 160,
                        HEIGHT // 2 + 80 + idx * 28))

    elif game_state == STATE_PLAYING:
        # Return to menu shortcut
        if keys[pygame.K_ESCAPE]:
            game_state = STATE_MENU

        # 360-Degree Aiming Adjustment
        if keys[pygame.K_LEFT]:
            aim_angle = (aim_angle + 120.0 * dt) % 360.0
        if keys[pygame.K_RIGHT]:
            aim_angle = (aim_angle - 120.0 * dt) % 360.0

        # Power charging
        if keys[pygame.K_SPACE] and not projectile:
            charging = True
            power = min(100.0, power + 50.0 * dt)
        elif charging:
            # Fire arrow projectile in full 360 direction
            rad = math.radians(aim_angle)
            speed = power * 12.0
            vx = speed * math.cos(rad)
            vy = -speed * math.sin(rad)  # Invert Y for screen coordinates
            projectile = [worm_pos[0], worm_pos[1], vx, vy]
            power = 0.0
            charging = False

        # Projectile Physics Update
        if projectile:
            projectile[3] += 500.0 * dt  # Gravity
            projectile[0] += projectile[2] * dt
            projectile[1] += projectile[3] * dt

            px, py = int(projectile[0]), int(projectile[1])

            # World boundaries and terrain collision check
            if 0 <= px < WIDTH and 0 <= py < HEIGHT:
                if terrain.get_at((px, py)).a > 0:  # Hit solid terrain
                    destroy_terrain(terrain, px, py, 35)
                    projectile = None
            else:
                if py >= HEIGHT or px < 0 or px >= WIDTH:
                    projectile = None

        # Render World
        screen.fill(SKY_BLUE)
        screen.blit(terrain, (0, 0))

        # Draw Active Player Worm
        pygame.draw.circle(
            screen, RED, (int(worm_pos[0]), int(worm_pos[1])), 10
        )

        # Draw Player Indicator Arrow (Floating above worm)
        hover_y = worm_pos[1] - 30 + math.sin(bounce_timer) * 4
        draw_arrow(
            screen, GOLD, (worm_pos[0], hover_y - 15), math.pi / 2, length=15)

        # Draw 360 Aim Vector Line
        rad = math.radians(aim_angle)
        line_len = 30 + power * 0.3
        end_x = worm_pos[0] + line_len * math.cos(rad)
        end_y = worm_pos[1] - line_len * math.sin(rad)
        pygame.draw.line(screen, WHITE, worm_pos, (end_x, end_y), 2)

        # Draw In-Flight Arrow Projectile
        if projectile:
            flight_angle = math.atan2(projectile[3], projectile[2])
            draw_arrow(
                screen,
                BLACK,
                (projectile[0], projectile[1]),
                flight_angle,
                length=20,
            )

        # HUD Overlay
        pwr_txt = font_ui.render(
            f"Power: {int(power)}%  |  Angle: {int(aim_angle)}°", True, BLACK)
        screen.blit(pwr_txt, (20, 20))

    pygame.display.flip()

pygame.quit()
sys.exit()
