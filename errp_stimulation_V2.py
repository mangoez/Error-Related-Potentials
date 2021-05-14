import pygame
from datetime import datetime
from random import seed
from random import randint
import itertools
import serial


square_step = 400
colours = list(itertools.permutations([0,128,255])) + \
          list(itertools.permutations([0,128,128])) + \
          list(itertools.permutations([0,128,0])) + \
          list(itertools.permutations([0,0,255])) + \
          list(itertools.permutations([0,255,255]))
colours.append((255,255,255))
colours = list(set(colours))

error_y = []
# feedback_start = []

cross = pygame.image.load('cross.png')
tick = pygame.image.load('tick.png')


def redraw_bg(surface):
    surface.fill((0,0,0))
    pygame.draw.rect(surface, (200, 200, 200), (340, 500, 1000, 200))
    pygame.draw.rect(surface, (200, 200, 200), (740, 0, 200, 500))

def draw_rects(surface, colour, colour2, square_direction):
    pygame.draw.rect(surface, colour, (715 + (square_step*square_direction), 475, 250, 250))
    pygame.draw.rect(surface, (200,200,200), (740 + (square_step*square_direction), 500, 200, 200))

    pygame.draw.rect(surface, colour2, (715 + (square_step*square_direction*-1), 475, 250, 250))
    pygame.draw.rect(surface, (200,200,200), (740 + (square_step*square_direction*-1), 500, 200, 200))



def move_circle_down(surface, colour, colour2, x, y, limit, step, square_direction):
    while (y <= limit):
        draw_rects(surface, colour, colour2, square_direction)
        pygame.draw.circle(surface, colour, (x, y), 90)
        pygame.display.update()

        y += step
        pygame.time.delay(1000)
        redraw_bg(surface)


def move_circle_horiz(surface, direction, colour, colour2, x, y, step, square_direction):
    redraw_bg(surface)

    x += (step*direction)

    draw_rects(surface, colour, colour2, square_direction)
    pygame.draw.circle(surface, colour, (x, y), 90)

    if (direction == square_direction):
        surface.blit(tick, (735,500))
    else:
        surface.blit(cross, (735,500))

    pygame.display.update()
    # feedback_start.append(datetime.now()) # Record time
    arduino.write(b'1')
    print("recorded")

    pygame.time.delay(1000)
    redraw_bg(surface)


def main():
    pygame.init()

    # win = pygame.display.set_mode((0, 0), pygame.FULLSCREEN)
    win = pygame.display.set_mode((1620, 800))

    pygame.display.set_caption("ErrP Experimental paradigm")

    run = True
    trials = 100
    origin_x = 840
    origin_y = 100

    redraw_bg(win)

    pygame.display.update() # Display rectangles



    while run:
        for i in range(trials):
            randomiser = (-1)**(randint(1, 10) <= 2) # 30% chance of being the other way
            orig_direction = ((-1)**(randint(1, 2) == 2))
            direction = orig_direction * randomiser

            if (randomiser == -1):
                error_y.append(1)
                print(1)
            else:
                error_y.append(0)
                print(0)

            colour = colours[randint(0,len(colours)-1)]
            colours2 = colours.copy()
            colours2.remove(colour)
            colour2 = colours2[randint(0,len(colours)-2)]

            move_circle_down(win, colour, colour2, origin_x, origin_y, 700, 250, orig_direction)
            move_circle_horiz(win, direction, colour, colour2, origin_x, 600, 400, orig_direction)
        run = False


    # feedback_start_s = [0]
    # for i in range(1, len(feedback_start)):
    #     feedback_start_s.append(round(((feedback_start[i]-feedback_start[0]).total_seconds()) * 125))

    # print(error_y, feedback_start_s, feedback_start)
    print(error_y)


if __name__ == '__main__':
    arduino = serial.Serial(port='/dev/tty.usbmodem14201', baudrate=115200, timeout=.1)
    print("Connection establised")

    main()
    pygame.quit()
