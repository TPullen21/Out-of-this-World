//
//  OuterSpaceTableViewController.m
//  Out of this World
//
//  Created by Tom Pullen on 07/10/2014.
//
//

#import "OuterSpaceTableViewController.h"
#import "AstronomicalData.h"
#import "SpaceObject.h"
#import "SpaceImageViewController.h"
#import "SpaceDataViewController.h"

@interface OuterSpaceTableViewController ()

@end

@implementation OuterSpaceTableViewController
#define ADDED_SPACE_OBJECTS_KEY @"Added Space Objects Array"

#pragma mark - Lazy Instantiation of Properties

- (NSMutableArray *)planets {
    if (!_planets) {
        _planets = [[NSMutableArray alloc] init];
    }
    return _planets;
}

- (NSMutableArray *)addedSpaceObjects {
    if (!_addedSpaceObjects) {
        _addedSpaceObjects = [[NSMutableArray alloc] init];
    }
    return _addedSpaceObjects;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    for (NSMutableDictionary *planetData in [AstronomicalData allKnownPlanets]) {
        NSString *imageName = [NSString stringWithFormat:@"%@.jpg", planetData[PLANET_NAME]];
        SpaceObject *planet = [[SpaceObject alloc] initWithData:planetData andImage:[UIImage imageNamed:imageName]];
        [self.planets addObject:planet];
        
    }
    
    NSArray *myPlanetsAsPropertyLists = [[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_SPACE_OBJECTS_KEY];
    
    for (NSDictionary *dictionary in myPlanetsAsPropertyLists) {
        SpaceObject *spaceObject = [self spaceObjectForDictionary:dictionary];
        [self.addedSpaceObjects addObject:spaceObject];
    }
    
//    NSString *planet1 = @"Mercury";
//    NSString *planet2 = @"Venus";
//    NSString *planet3 = @"Earth";
//    NSString *planet4 = @"Mars";
//    NSString *planet5 = @"Jupiter";
//    NSString *planet6 = @"Saturn";
//    NSString *planet7 = @"Uranus";
//    NSString *planet8 = @"Neptune";
//    NSString *planet9 = @"Pluto";
//
//    self.planets = [[NSMutableArray alloc] initWithObjects:planet1, planet2, planet3, planet4, planet5, planet6, planet7, planet8, planet9, nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        if ([segue.destinationViewController isKindOfClass:[SpaceImageViewController class]]) {
            SpaceImageViewController *nextViewController = segue.destinationViewController;
            NSIndexPath *path = [self.tableView indexPathForCell:sender];
            if (path.section == 1) {
                SpaceObject *selectedObject = [self.addedSpaceObjects objectAtIndex:path.row];
                nextViewController.spaceObject = selectedObject;
            }
            else {
                SpaceObject *selectedObject = [self.planets objectAtIndex:path.row];
                nextViewController.spaceObject = selectedObject;
            }
        }
    }
    
    if ([sender isKindOfClass:[NSIndexPath class]]) {
        if ([segue.destinationViewController isKindOfClass:[SpaceDataViewController class]]) {
            SpaceDataViewController *targetViewController = segue.destinationViewController;
            NSIndexPath *path = sender;
            if (path.section == 1) {
                SpaceObject *selectedObject = self.addedSpaceObjects[path.row];
                targetViewController.spaceObject = selectedObject;
            }
            else {
                SpaceObject *selectedObject = self.planets[path.row];
                targetViewController.spaceObject = selectedObject;
            }
        }
    }
    
    if ([segue.destinationViewController isKindOfClass:[AddSpaceObjectViewController class]]) {
        AddSpaceObjectViewController *addSpaceObjectVC = segue.destinationViewController;
        addSpaceObjectVC.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AddSpaceObjectViewController Delegate

- (void)didCancel {
    NSLog(@"Did Cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addSpaceObject:(SpaceObject *)spaceObject {
    
    [self.addedSpaceObjects addObject:spaceObject];
    
    // Will save to NSUserDefaults here
    NSMutableArray *spaceObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_SPACE_OBJECTS_KEY] mutableCopy];
    
    if (!spaceObjectsAsPropertyLists) spaceObjectsAsPropertyLists = [[NSMutableArray alloc] init];
    
    [spaceObjectsAsPropertyLists addObject:[self spaceObjectAsAPropertyList:spaceObject]];
    [[NSUserDefaults standardUserDefaults] setObject:spaceObjectsAsPropertyLists forKey:ADDED_SPACE_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.tableView reloadData];
}

#pragma mark - Helper Methods

- (NSDictionary *)spaceObjectAsAPropertyList:(SpaceObject *)spaceObject {
    
    NSData *imageData = UIImagePNGRepresentation(spaceObject.spaceImage);
    
    NSDictionary *dictionary = @{
                                 PLANET_NAME                : spaceObject.name,
                                 PLANET_GRAVITY             : @(spaceObject.gravitationalForce),
                                 PLANET_DIAMETER            : @(spaceObject.diameter),
                                 PLANET_YEAR_LENGTH         : @(spaceObject.yearLength),
                                 PLANET_DAY_LENGTH          : @(spaceObject.dayLength),
                                 PLANET_TEMPERATURE         : @(spaceObject.temperature),
                                 PLANET_NUMBER_OF_MOONS     : @(spaceObject.numberOfMoons),
                                 PLANET_NICKNAME            : spaceObject.nickName,
                                 PLANET_INTERESTING_FACT    : spaceObject.interestingFact,
                                 PLANET_IMAGE               : imageData
                                 };
    return dictionary;
}

- (SpaceObject *)spaceObjectForDictionary:(NSDictionary *)dictionary {
    UIImage *spaceObjectImage = [UIImage imageWithData:dictionary[PLANET_IMAGE]];
    return [[SpaceObject alloc] initWithData:dictionary andImage:spaceObjectImage];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    
    if ([self.addedSpaceObjects count]) {
        return 2;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
//    if (section == 0) {
//        return 2;
//    }
//    else if (section == 1) {
//        return 1;
//    }
//    else {
//        return 3;
//    }
    
    if (section == 1) {
        return [self.addedSpaceObjects count];
    }
    
    return [self.planets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (indexPath.section == 1) {
        SpaceObject *planet = [self.addedSpaceObjects objectAtIndex:indexPath.row];
        
        cell.textLabel.text = planet.name;
        cell.detailTextLabel.text = planet.nickName;
        cell.imageView.image = planet.spaceImage;
    }
    else {
        SpaceObject *planet = [self.planets objectAtIndex:indexPath.row];
        
        cell.textLabel.text = planet.name;
        cell.detailTextLabel.text = planet.nickName;
        cell.imageView.image = planet.spaceImage;
        
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    
    return cell;
}

#pragma mark UITableView Delgate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"Push To Space Data" sender:indexPath];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) return YES;
    
    return NO;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.addedSpaceObjects removeObjectAtIndex:indexPath.row];
        
        NSMutableArray *newSavedSpaceObjectData = [[NSMutableArray alloc] init];
        
        for (SpaceObject *spaceObject in self.addedSpaceObjects) {
            [newSavedSpaceObjectData addObject:[self spaceObjectAsAPropertyList:spaceObject]];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:newSavedSpaceObjectData forKey:ADDED_SPACE_OBJECTS_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
