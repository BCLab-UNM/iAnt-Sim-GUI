#import "SimulationView.h"

@implementation SimulationView

using namespace std;

@synthesize simulation, robots, team, grid, pheromones, regions, clusters;

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
        
        for(float i = 0; i < gridSize.width; i++) {
            [[NSColor grayColor] set];
            NSBezierPath* path = [NSBezierPath bezierPath];
            [path setLineWidth:.5];
            [path moveToPoint:NSMakePoint(roundf((i/gridSize.width)*self.frame.size.width),0)];
            [path lineToPoint:NSMakePoint(roundf((i/gridSize.width)*self.frame.size.width),h)];
            [path stroke];
        }
        for(float i = 0; i < gridSize.height; i++) {
            [[NSColor grayColor] set];
            NSBezierPath* path = [NSBezierPath bezierPath];
            [path setLineWidth:.5];
            [path moveToPoint:NSMakePoint(0,roundf((i/gridSize.height)*self.frame.size.height))];
            [path lineToPoint:NSMakePoint(w,roundf((i/gridSize.height)*self.frame.size.height))];
            [path stroke];
        }
        
        for(Robot* robot in robots) {
            NSRect rect = NSMakeRect((robot.position.x/gridSize.width)*w, (robot.position.y/gridSize.height)*h, cellWidth, cellHeight);
            NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect:rect];
            
            if([[robot discoveredTags] count] > 0) {
                [[NSColor greenColor] set];
            }
            else if(robot.status == ROBOT_STATUS_DEPARTING) {
                [[NSColor redColor] set];
            }
            else if(robot.status == ROBOT_STATUS_SEARCHING) {
                [[NSColor purpleColor] set];
            }
            else if(robot.status == ROBOT_STATUS_RETURNING) {
                [[NSColor orangeColor] set];
            }
            [path fill];
            [[NSColor whiteColor] set];
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
                        [[NSColor magentaColor] set];
                    }
                    else {
                        [[NSColor whiteColor] set];
                    
                    }
                    [path setLineWidth:2];
                    [path fill];
                    [path setLineWidth:1];
                    [[NSColor darkGrayColor] set];
                    [path stroke];
                }
            }
        }
        
        for(Pheromone* pheromone in pheromones) {
            [[NSColor colorWithCalibratedRed:0. green:.6 blue:0. alpha:1.] set];
            NSBezierPath* path = [NSBezierPath bezierPath];
            [path setLineWidth:3 * [pheromone weight]];
            [path moveToPoint:NSMakePoint(simulation.nest.x * cellWidth + (cellWidth / 2), simulation.nest.y * cellHeight + (cellHeight / 2))];
            [path lineToPoint:NSMakePoint([pheromone position].x * cellWidth + (cellWidth / 2), [pheromone position].y * cellHeight + (cellHeight / 2))];
            [path stroke];
        }
        
        for(QuadTree* region in regions) {
            [[NSColor redColor] set];
            NSRect rect = NSMakeRect([region shape].origin.x * cellWidth, [region shape].origin.y * cellHeight,
                                     [region shape].size.width * cellWidth, [region shape].size.height * cellHeight);
            NSBezierPath* path = [NSBezierPath bezierPathWithRect:rect];
            [path setLineWidth:1];
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

-(void) updateDisplayWindowWithRobots:(NSMutableArray*)_robots team:(Team*)_team grid:(vector<vector<Cell*>>)_grid pheromones:(NSMutableArray*)_pheromones regions:(NSMutableArray*)_regions clusters:(NSMutableArray *)_clusters {
    robots = _robots;
    team = _team;
    grid = _grid;
    pheromones = _pheromones;
    regions = _regions;
    clusters = _clusters;
    [self redraw];
}

@end
