//
//  ToDoTableViewTableViewController.m
//  MobDevMyToDoList
//
//  Created by Filippo on 25/11/20.
//  Copyright © 2020 Filippo. All rights reserved.
//

#import "ToDoTableViewTableViewController.h"
#import "TodoTableViewCell.h"
#import "ToDo+CoreDataClass.h"
#import "ShowToDoViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface ToDoTableViewTableViewController () 

@end

@implementation ToDoTableViewTableViewController

/*
 All'interno del metodo viewDidLoad andiamo a fare il setup di base dei componenti
 definendo il delegate e il datasource della tableView
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getNSManagedObjectContext];
    self.toDoTable.delegate = self;
    self.toDoTable.dataSource = self;
    [self.toDoTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 All'interno del metodo viewWillAppear andiamo a recuperare il filtro, se presente,
 in quanto questa vista può essere richiamata dal tabbar controller, e quindi senza alcun filtro
 sui contenuti, oppure dal searchController con un opportuno filtraggio dei contenuti.
 A seconda dei casi viene richiamato il rispettivo metodo per recuperare i dati da CoreData e
 infine viene fatto il reload della table
 */
 
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (self.filter == nil)
        [self fetchDataFromCoreData];
    else{
        [self fetchFilterData];
        NSLog(@"filtro ottenuto %@", self.filter.description);
    }
    [self.toDoTable reloadData];
}

/*
 In questo metodo recuperiamo il context che ci servirà per accedere ai dati dell'app
 */


- (void)getNSManagedObjectContext {
    _appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    _context = _appDelegate.persistentContainer.viewContext;
    
}

/*
 In questo metodo recuperiamo i dati da coredata nel caso la vista sia richiamata dal tabbar
 quindi filtrando i dati su: stato (non completati), sulla data di scadenza (oggi oppure nessuna) e infine
 sulla data di completamento (oggi)
 */


- (void) fetchDataFromCoreData {
    NSFetchRequest *requestTodos = [[NSFetchRequest alloc]initWithEntityName:@"ToDo"];
    NSError *error = nil;
    NSLocale* currentLocale = [NSLocale currentLocale];
    NSDate *currentTime = [[NSDate alloc]init];
    [currentTime descriptionWithLocale:currentLocale];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/YYYY"];
    NSString *today = [NSString stringWithFormat:@"%@",[formatter stringFromDate:currentTime]];
    requestTodos.predicate = [NSPredicate predicateWithFormat:@"state == 0 AND (dueDate == %@ OR dueDate == nil) OR doneDate == %@",today,today];
    NSSortDescriptor *firstSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"state" ascending:YES];
    NSSortDescriptor *secondSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:firstSortDescriptor, secondSortDescriptor, nil];
    [requestTodos setSortDescriptors:sortDescriptors];
    if (_context != nil ){
        _todos = [[_context executeFetchRequest:requestTodos error:&error] mutableCopy];
        if(error != nil) {
            NSLog(@"Error %@", error);
        }
        else {
            
        }
        NSLog(@"name is %@", [_todos valueForKey: @"name"]);
    }
}

/*
 In questo metodo recuperiamo i dati da CoreData con un opportuno filtraggio determinato dalla segue che richiama
 questa vista.. Viene verificato quali campi del filtro siano diversi da nil e a seconda dei casi vengono aggiunti
 i filtri alle richieste sui dati
 */
- (void) fetchFilterData {
    NSFetchRequest *requestTodos = [[NSFetchRequest alloc]initWithEntityName:@"ToDo"];
    NSError *error = nil;
    NSMutableArray<NSPredicate *> *predicates = [NSMutableArray new];
    if(self.filter.state != -1) {
        NSPredicate *categoryPredicate = [NSPredicate predicateWithFormat:@"state == %d", self.filter.state];
        [predicates addObject:categoryPredicate];
    }
    if (![self.filter.category isEqualToString:@"nil"]) {
        NSLog(@"%@" , self.filter.category);
        NSPredicate *categoryPredicate = [NSPredicate predicateWithFormat:@"category == %@", self.filter.category];
        [predicates addObject:categoryPredicate];
        NSLog(@"%@ category", categoryPredicate);
    }
    if (![self.filter.dueDate isEqualToString:@"nil"]) {
        NSPredicate *dueDatePredicate = [NSPredicate predicateWithFormat:@"dueDate == %@", self.filter.dueDate];
        [predicates addObject:dueDatePredicate];
        NSLog(@"%@ category", dueDatePredicate);
    }
    if (![self.filter.creationDate isEqualToString:@"nil"]) {
        NSPredicate *creationDatePredicate = [NSPredicate predicateWithFormat:@"creationDate == %@", self.filter.creationDate];
        [predicates addObject:creationDatePredicate];
        NSLog(@"%@ category", creationDatePredicate);
    }
    if( predicates.count != 0) {
        NSPredicate *andPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
        requestTodos.predicate = andPredicate;
        NSLog(@"All %@", predicates);
    }
    if (_context != nil ){
        _todos = [[_context executeFetchRequest:requestTodos error:&error] mutableCopy];
        if(error != nil) {
            
        }
        else {
            NSLog(@"Error %@", error.description);
        }
    }
}

#pragma mark - Table view data source

/*
 Questi due metodi stabiliscono il numero di sezioni (una) e il numero di elementi all'interno della
 table (il numero dei todo trovati su coredata
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _todos.count;
}

/*
 Questo metodo setta il contenuto all'interno delle celle della table. Inoltre viene specificato il
 delegato della cella (per recuperare il pulsante di info)
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TodoTableViewCell *cell =(TodoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cardCell"];
    ToDo *todo = (ToDo *) _todos[indexPath.row];
    cell.titleLabel.text = todo.name;
    cell.categoryLabel.text = todo.category;
    cell.todo = todo;
    cell.delegate = self;
    cell.cellIndex = indexPath.row;
    if(todo.state)
        [cell.doneImg setHidden:NO];
    else
        [cell.doneImg setHidden:YES];

    cell.dueDateLabel.text = todo.dueDate;
    return cell;
}

/*
 Questo metodo permette di definire il compoprtamento dopo un click sulla cella. In
 questo caso viene richiamato un gestureRecognizer per rilevare il doppio click
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTouchesRequired = 1;
    doubleTap.numberOfTapsRequired = 2;
    self.toDoTable.userInteractionEnabled = YES;
    [self.toDoTable addGestureRecognizer:doubleTap];
}

/*
 Metodo richiamato dal gesture recognizer dopo un doppio click.
 Definisce il completamento di un todo, apporta le modifiche su coredata ed infine fa
 il reload della table per mostrare il checkmark di completamento
 */
-(void)doubleTap: (UITapGestureRecognizer*)sender {
    NSLog(@"DoubleTap");
    NSIndexPath *indexPath = [self.toDoTable indexPathForSelectedRow];
    TodoTableViewCell *selectedCell=[self.toDoTable cellForRowAtIndexPath:indexPath];
    [selectedCell.doneImg setHidden:false];
    ToDo *selectedToDo = _todos[indexPath.row];
    [self removeNotificationForTodo:selectedToDo];
    selectedToDo.state = true;
    NSLocale* currentLocale = [NSLocale currentLocale];
    NSDate *currentTime = [[NSDate alloc]init];
    [currentTime descriptionWithLocale:currentLocale];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/YYYY"];
    selectedToDo.doneDate = [NSString stringWithFormat:@"%@",[formatter stringFromDate:currentTime]];
    [_appDelegate saveContext];
    [self.toDoTable reloadData];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



/*
 Questo metodo permette di eliminare una cella attraverso una swipe, la cella viene eliminata anche
 nel coredata e, inoltre, viene richiamato il metodo di rimozione della notifica,se presente, nel notificationcenter
 */

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        ToDo *toDelete = _todos[[indexPath row]];
        if(toDelete.dueDate.length != 0)
            [self removeNotificationForTodo:toDelete];
        
        [_context deleteObject:toDelete];
        [_todos removeObjectAtIndex:indexPath.row];
        [self.toDoTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_appDelegate saveContext];
        
       
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
 Questo metodo permette la rimozione della notifica all'interno del notificationcenter
 */

- (void) removeNotificationForTodo: (ToDo *) todo {
    NSString *notificationID = [NSString stringWithFormat:@"%@ %@", todo.name, todo.dueDate];
    NSArray *pendingNotifications = [NSArray arrayWithObjects:notificationID, nil];
    [UNUserNotificationCenter.currentNotificationCenter removePendingNotificationRequestsWithIdentifiers:pendingNotifications];
    NSLog(@"Removed notification with id: %@", notificationID);
}



#pragma mark - Navigation
/*
 Dato che è conforme al delegate di cella dobbiamo definire il comportamento per il
 click sul pulsante presente all'interno della cella.
 Viene mostrata la vista contentente le info riguardo il todo selezionato
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"infoSegue"]) {
        if([segue.destinationViewController isKindOfClass:[ShowToDoViewController class]]){
            ShowToDoViewController *destViewController = segue.destinationViewController;
            destViewController.todo = _selectedToDo;

        }
    }
}

- (void)didClickOnCellAtIndex:(NSInteger)cellIndex withData:(id)data
{
    // Do additional actions as required.
    NSLog(@"cliccato su  %@",  data);
    _selectedToDo = data;
}


@end
