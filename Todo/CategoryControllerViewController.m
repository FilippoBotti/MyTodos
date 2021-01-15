//
//  CategoryControllerViewController.m
//  Todo
//
//  Created by Filippo on 13/01/21.
//  Copyright © 2021 Filippo. All rights reserved.
//

#import "CategoryControllerViewController.h"
#import "CategoryTableViewCell.h"
#import "Category+CoreDataClass.h"
@interface CategoryControllerViewController ()

@end

@implementation CategoryControllerViewController

/*
 All'interno del viewdidload deifiniamo il setup iniziale dei componenti
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cardSetup];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self getNSManagedObjectContext];
}

/*
 Recuperiamo i dati da coredata e effettuiamo il reload
 */

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self fetchDataFromCoreData];
    [self.tableView reloadData];
}

     
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 Recuperiamo il context
 */

- (void)getNSManagedObjectContext {
    _appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    _context = _appDelegate.persistentContainer.viewContext;
    
}

/*
 Recuperiamo i dati da coredata per quanto riguarda le categorie
 */
- (void) fetchDataFromCoreData {
    NSFetchRequest *requestCategory = [[NSFetchRequest alloc]initWithEntityName:@"Category"];
    NSError *error = nil;
    if (_context != nil ){
        _categories = [[_context executeFetchRequest:requestCategory error:&error] mutableCopy];
        if(error != nil) {
            NSLog(@"Error %@", error);
        }
        else {
            
        }
        NSLog(@"name is %@", [_categories valueForKey: @"name"]);
    }
}

- (void) cardSetup {
    [self.topCard setAlpha:1];
    self.topCard.layer.masksToBounds = true;
    self.topCard.layer.borderWidth = 0;
    self.topCard.layer.cornerRadius = 10; // if you like rounded corners
    self.topCard.layer.shadowOffset = CGSizeMake(-.2f, .2f); //%%% this shadow will hang slightly down and to the right
    self.topCard.layer.shadowRadius = 2; //%%% I prefer thinner, subtler shadows, but you can play with this
    self.topCard.layer.shadowOpacity = 1.0; //%%% same thing with this, subtle is better for me
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.topCard.bounds];
    self.topCard.layer.shadowPath = path.CGPath;
    
    [self.tableCard setAlpha:1];
    self.tableCard.layer.masksToBounds = true;
    self.tableCard.layer.borderWidth = 0;
    self.tableCard.layer.cornerRadius = 10; // if you like rounded corners
    self.tableCard.layer.shadowOffset = CGSizeMake(-.2f, .2f); //%%% this shadow will hang slightly down and to the right
    self.tableCard.layer.shadowRadius = 2; //%%% I prefer thinner, subtler shadows, but you can play with this
    self.tableCard.layer.shadowOpacity = 1.0; //%%% same thing with this, subtle is better for me
    self.tableCard.layer.shadowPath = path.CGPath;
}

/*
 Definiamo la vista all'interno della cella
 */

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CategoryTableViewCell *cell = (CategoryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"categoryCard"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Category *category = [_categories objectAtIndex:indexPath.row];
    cell.name.text = category.name;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _categories.count;
}

/*
 Definiamo il metodo per eliminare una categoria dalla tabella
 */

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Category *toDelete = _categories[[indexPath row]];
        
        [_context deleteObject:toDelete];
        [_categories removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_appDelegate saveContext];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

/*
 Definiamo il comportamento del pulsante salva che dopo aver verificato il corretto inserimento
 della categoria la salva nel coredata
 */

- (IBAction)saveCategory:(id)sender {
    
    if(self.categoryTextField.text.length != 0) {
        NSLog(@"%@ " ,self.categoryTextField.text);
        Category *entityObj = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:_context];
        entityObj.name = self.categoryTextField.text;
        // Save the object to persistent store
        NSError *error = nil;
        if (![_context save:&error]) {
            NSLog(@"Can't Save! %@", error);
        }
        else {
            NSLog(@"Todo correctly saved %@", entityObj);
            self.categoryTextField.text = @"";
            [self fetchDataFromCoreData];
            [self.tableView reloadData];
        }
    }
}
@end
