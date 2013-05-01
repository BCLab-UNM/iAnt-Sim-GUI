#import "SimulationView.h"
#import "AntBot-GA/GA.h"

@implementation SimulationView

@synthesize robots, team, tags, pheromones;

-(void) awakeFromNib {
    [self translateOriginToPoint:NSMakePoint(0,0)];
}

-(void) drawRect:(NSRect)dirtyRect {
    float w = self.frame.size.width,
          h = self.frame.size.height;
    float cellWidth = (1./gridWidth) * w,
          cellHeight = (1./gridHeight) * h;
    
    //Clear background.
    [[NSColor blackColor] set];
    NSRectFill(dirtyRect);
    
    //Draw Nest.
    NSRect rect = NSMakeRect(w/2 - cellWidth,h/2 - cellHeight, cellWidth * 2, cellHeight * 2);
    NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect:rect];
    
    [[NSColor blackColor] set];
    [path fill];
    [[NSColor whiteColor] set];
    [path stroke];
    
    for(float i = 0; i < gridWidth; i++) {
        [[NSColor grayColor] set];
        NSBezierPath* path = [NSBezierPath bezierPath];
        [path setLineWidth:.5];
        [path moveToPoint:NSMakePoint(roundf((i/gridWidth)*self.frame.size.width),0)];
        [path lineToPoint:NSMakePoint(roundf((i/gridWidth)*self.frame.size.width),h)];
        [path stroke];
    }
    for(float i = 0; i < gridHeight; i++) {
        [[NSColor grayColor] set];
        NSBezierPath* path = [NSBezierPath bezierPath];
        [path setLineWidth:.5];
        [path moveToPoint:NSMakePoint(0,roundf((i/gridHeight)*self.frame.size.height))];
        [path lineToPoint:NSMakePoint(w,roundf((i/gridHeight)*self.frame.size.height))];
        [path stroke];
    }
    
    for(Robot* robot in [robots copy]) {
        NSRect rect = NSMakeRect((robot.position.x/gridWidth)*w,(robot.position.y/gridHeight)*h,cellWidth, cellHeight);
        NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect:rect];
        
        if(robot.carrying != nil){[[NSColor greenColor] set];}
        else if(robot.status == ROBOT_STATUS_DEPARTING){[[NSColor redColor] set];}
        else if(robot.status == ROBOT_STATUS_SEARCHING){[[NSColor purpleColor] set];}
        else if(robot.status == ROBOT_STATUS_RETURNING){[[NSColor orangeColor] set];}
        [path fill];
        [[NSColor whiteColor] set];
        [path stroke];
        
        if (robot.recruitmentTarget.x > 0) {
            float range = exponentialDecay(wirelessRange, robot.searchTime, team.informedSearchCorrelationDecayRate);
            rect = NSMakeRect(((robot.position.x - range/2)/gridWidth)*w, ((robot.position.y - range/2)/gridHeight)*h, range*cellWidth, range*cellHeight);
            path = [NSBezierPath bezierPathWithOvalInRect:rect];
            [[NSColor colorWithCalibratedRed:0. green:.5 blue:1. alpha:1.] set];
            [path stroke];
        }
    }

    for(Tag* tag in [tags copy]) {
        if (![tag isKindOfClass:[NSNull class]]) {
            NSRect rect = NSMakeRect(((float)tag.x/gridWidth)*w + (cellWidth*.25),((float)tag.y/gridHeight)*h + (cellWidth*.25),cellWidth*.5, cellHeight*.5);
            NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect:rect];
            
            if(tag.pickedUp){[[NSColor blackColor] set];}
            else{[[NSColor whiteColor] set];}
            [path setLineWidth:2];
            [path fill];
            [path setLineWidth:1];
            [[NSColor darkGrayColor] set];
            [path stroke];
        }
    }
    
    for(Pheromone* pheromone in [pheromones copy]) {
        [[NSColor colorWithCalibratedRed:0. green:.6 blue:0. alpha:1.] set];
        NSBezierPath* path = [NSBezierPath bezierPath];
        [path setLineWidth:3*pheromone.n];
        [path moveToPoint:NSMakePoint(w/2,h/2)];
        [path lineToPoint:NSMakePoint(((float)pheromone.x/gridWidth)*w,((float)pheromone.y/gridHeight)*h)];
        [path stroke];
    }
}

-(void) updateDisplayWindowWithRobots:(NSMutableArray*)_robots team:(Team*)_team tags:(Array2D*)_tags pheromones:(NSMutableArray*)_pheromones {
    robots = _robots;
    team = _team;
    tags = _tags;
    pheromones = _pheromones;
    [self setNeedsDisplay:YES];
}

-(void) magnifyWithEvent:(NSEvent*) event {
    double m = [event magnification];
    if(m > 0) {
        self.frame = NSMakeRect(self.frame.origin.x + 100, self.frame.origin.y + 100, self.frame.size.width - 200, self.frame.size.height - 200);
    }
    else {
        self.frame = NSMakeRect(self.frame.origin.x - 100, self.frame.origin.y - 100, self.frame.size.width + 200, self.frame.size.height + 200);
    }
}

@end
