#import "SimulationView.h"
#import "AntBot-GA/GA.h"

@interface Pheromone2 : NSObject {}
@property (nonatomic) int x;
@property (nonatomic) int y;
@property (nonatomic) float n;
@property (nonatomic) int updated;
@end

@implementation Pheromone2
@synthesize x,y,n,updated;
@end

@implementation SimulationView

@synthesize robots, tags, pheromones;

-(void) awakeFromNib {
    [self translateOriginToPoint:NSMakePoint(0,0)];
}

-(void) drawRect:(NSRect)dirtyRect {
    float w = self.frame.size.width,
          h = self.frame.size.height;
    float cellWidth = (1/90.f) * w,
          cellHeight = (1/90.f) * h;
    
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
    
    for(float i = 0; i < 90; i++) {
        [[NSColor grayColor] set];
        NSBezierPath* path = [NSBezierPath bezierPath];
        [path setLineWidth:.5];
        [path moveToPoint:NSMakePoint(roundf((i/90.)*self.frame.size.width),0)];
        [path lineToPoint:NSMakePoint(roundf((i/90.)*self.frame.size.width),h)];
        [path stroke];
    }
    for(float i = 0; i < 90; i++) {
        [[NSColor grayColor] set];
        NSBezierPath* path = [NSBezierPath bezierPath];
        [path setLineWidth:.5];
        [path moveToPoint:NSMakePoint(0,roundf((i/90.)*self.frame.size.height))];
        [path lineToPoint:NSMakePoint(w,roundf((i/90.)*self.frame.size.height))];
        [path stroke];
    }
    
    for(Robot* robot in robots) {
        NSRect rect = NSMakeRect((robot.position.x/90.f)*w,(robot.position.y/90.f)*h,cellWidth, cellHeight);
        NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect:rect];
        
        if(robot.carrying != nil){[[NSColor greenColor] set];}
        else if(robot.status == ROBOT_STATUS_DEPARTING){[[NSColor redColor] set];}
        else if(robot.status == ROBOT_STATUS_SEARCHING){[[NSColor purpleColor] set];}
        else if(robot.status == ROBOT_STATUS_RETURNING){[[NSColor orangeColor] set];}
        [path fill];
        [[NSColor whiteColor] set];
        [path stroke];
    }
    
    /*for(Ant* ant in ants){
        NSRect rect = NSMakeRect((ant.target.x/90.f)*self.frame.size.width-2,(ant.target.y/90.f)*self.frame.size.height-2,4,4);
        NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect:rect];
        
        if(ant.carrying != nil){[[NSColor greenColor] set];}
        else if(ant.status == ANT_STATUS_DEPARTING){[[NSColor redColor] set];}
        else if(ant.status == ANT_STATUS_SEARCHING){[[NSColor purpleColor] set];}
        else if(ant.status == ANT_STATUS_RETURNING){[[NSColor orangeColor] set];}
        [path fill];
        [[NSColor whiteColor] set];
        [path stroke];
    }*/
    
    for(Tag* tag in tags) {
        NSRect rect = NSMakeRect((tag.x/90.f)*w + (cellWidth*.25),(tag.y/90.f)*h + (cellWidth*.25),cellWidth*.5, cellHeight*.5);
        NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect:rect];
        
        if(tag.pickedUp){[[NSColor blackColor] set];}
        else{[[NSColor whiteColor] set];}
        [path setLineWidth:2];
        [path fill];
        [path setLineWidth:1];
        [[NSColor darkGrayColor] set];
        [path stroke];
    }
    
    for(Pheromone2* pheromone in pheromones) {
        [[NSColor colorWithCalibratedRed:0. green:.6 blue:0. alpha:1.] set];
        NSBezierPath* path = [NSBezierPath bezierPath];
        [path setLineWidth:3*pheromone.n];
        [path moveToPoint:NSMakePoint(w/2,h/2)];
        [path lineToPoint:NSMakePoint((pheromone.x/90.f)*w,(pheromone.y/90.f)*h)];
        [path stroke];
    }
}

-(void) updateRobots:(NSMutableArray*)_robots tags:(NSMutableArray*)_tags pheromones:(NSMutableArray*)_pheromones {
    robots = [NSMutableArray arrayWithArray:_robots];
    tags = _tags;
    pheromones = _pheromones;
    [self setNeedsDisplay:YES];
}

-(void) updateAnts:(NSMutableArray*)ants {}

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
