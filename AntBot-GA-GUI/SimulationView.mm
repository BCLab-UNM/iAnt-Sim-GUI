#import "SimulationView.h"

@implementation SimulationView

using namespace std;

@synthesize simulation, robots, team, grid, pheromones, clusters;

-(void) awakeFromNib {
    [self translateOriginToPoint:NSMakePoint(0,0)];
}

-(void) redraw {
    if(drawTimer == nil) {
        drawTimer = [NSTimer timerWithTimeInterval:.016f target:self selector:@selector(drawTimerDidFire:) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:drawTimer forMode:NSDefaultRunLoopMode];
    }
}

-(void) drawTimerDidFire:(NSTimer*)timer {
    [drawTimer invalidate];
    drawTimer = nil;
    [self setNeedsDisplay:YES];
}

-(void) drawRect:(NSRect)dirtyRect {
    if (simulation) {
        float w = self.frame.size.width,
        h = self.frame.size.height;
        NSSize gridSize = simulation.gridSize;
        float cellWidth = w / gridSize.width,
        cellHeight = h /gridSize.height;
        
        //Clear background.
        [[NSColor blackColor] set];
        NSRectFill(dirtyRect);
        
        //Draw Nest as white circle with diameter of 3 centered at nest
        NSRect rect = NSMakeRect((simulation.nest.x * cellWidth) - cellWidth, (simulation.nest.y * cellHeight) - cellHeight, cellWidth * 3, cellHeight * 3);
        NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect:rect];
        
        [[NSColor blackColor] set];
        [path fill];
        [[NSColor whiteColor] set];
        [path stroke];
        
        for(Robot* robot in robots) {
            NSRect rect = NSMakeRect((robot.position.x/gridSize.width)*w, (robot.position.y/gridSize.height)*h, cellWidth, cellHeight);
            NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect:rect];
            
            if([[robot discoveredTags] count] > 0) {
                [[NSColor greenColor] set];
            }
            else if(robot.status == ROBOT_STATUS_DEPARTING) {
                [[NSColor cyanColor] set];
            }
            else if(robot.status == ROBOT_STATUS_SEARCHING) {
                [[NSColor magentaColor] set];
            }
            else if(robot.status == ROBOT_STATUS_RETURNING) {
                [[NSColor orangeColor] set];
            }
            [path setLineWidth:3];
            [path fill];
            //[[NSColor whiteColor] set];
            [path stroke];
        }
        
        for(vector<Cell*> v : grid) {
            for(Cell* cell : v) {
                Tag* tag = [cell tag];
                if (tag) {
                    NSRect rect = NSMakeRect(((float)[tag position].x/gridSize.width)*w + (cellWidth*.25),
                                             ((float)[tag position].y/gridSize.height)*h + (cellWidth*.25),cellWidth*.5, cellHeight*.5);
                    NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect:rect];
                    
                    if ([tag pickedUp]) {
                        [[NSColor blackColor] set];
                    }
                    else if ([tag discovered]) {
                        [[NSColor lightGrayColor] set];
                    }
                    else {
                        [[NSColor lightGrayColor] set];
                    
                    }
                    [path setLineWidth:3];
                    [path fill];
                    //[path setLineWidth:3];
                    //[[NSColor darkGrayColor] set];
                    [path stroke];
                }
                Obstacle* obstacle = [cell obstacle];
                if (obstacle) {
                    NSRect rect = NSMakeRect(((float)[obstacle position].x/gridSize.width)*w + (cellWidth*.25),
                                             ((float)[obstacle position].y/gridSize.height)*h + (cellWidth*.25),cellWidth*.5, cellHeight*.5);
                    NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect:rect];
                    [[NSColor brownColor] set];
                    [path setLineWidth:3];
                    [path fill];
                    //[path setLineWidth:3];
                    [path stroke];
                }
            }
            
        }
        
        for(Pheromone* pheromone in pheromones) {
            [[NSColor colorWithCalibratedRed:0. green:.6 blue:0. alpha:1.] set];
            NSBezierPath* path = [NSBezierPath bezierPath];
            [path setLineWidth:3 * [pheromone weight]];
			
			int pointCount = (int)[[pheromone path] count];
			if(pointCount >= 2) {
				for(int i = 0; i < pointCount; i++) {
					float x = [[[pheromone path] objectAtIndex:i] pointValue].x * cellWidth + (cellWidth / 2);
					float y = [[[pheromone path] objectAtIndex:i] pointValue].y * cellHeight + (cellHeight / 2);
					
					if(i == 0) {
						[path moveToPoint:NSMakePoint(x, y)];
					}
					else {
						[path lineToPoint:NSMakePoint(x, y)];
					}
				}
			}
			
            [path stroke];
        }
        
        for(Cluster* cluster in clusters) {
            [[NSColor blueColor] set];
            NSRect rect = NSMakeRect(([cluster center].x - [cluster width]/2) * cellWidth, ([cluster center].y - [cluster height]/2) * cellHeight, [cluster width] * cellWidth, [cluster height] * cellHeight);
            NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect:rect];
            [path setLineWidth:2];
            [path stroke];
        }
    }
}

-(void) updateDisplayWindowWithRobots:(NSMutableArray*)_robots team:(Team*)_team grid:(vector<vector<Cell*>>)_grid pheromones:(NSMutableArray*)_pheromones clusters:(NSMutableArray *)_clusters {
    robots = _robots;
    team = _team;
    grid = _grid;
    pheromones = _pheromones;
    clusters = _clusters;
    [self redraw];
}

@end
