//
//  StatsViewController.m
//  Todo
//
//  Created by Filippo on 08/01/21.
//  Copyright © 2021 Filippo. All rights reserved.
//

#import "StatsViewController.h"
#import "CardCollectionViewCell.h"
@interface StatsViewController ()

@end

@implementation StatsViewController

/*
 All'interno del viewdidload definiamo il setup iniziale dei componenti
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    nomi = @[@"Completati: ", @"Da Fare: ", @"Falliti: ", @"Totali: " ,  @"Oggi: " , @"Oggi: " ];
    self.cardCollectionView.delegate = self;
    self.cardCollectionView.dataSource = self;
    [self.cardCollectionView reloadData];
    [self getNSManagedObjectContext];
    self.welcomeLabel.text = @"Ecco i tuoi progressi:";
}

/*
 All'interno del viewwillapper facciamo il reload della collectionview per
 aggiornare i contatori
 */

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.cardCollectionView reloadData];
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
 Recuperiamo da coredata i valori che ci servono per i contatori
 */

-(void) fetchDataWithAttribute:(long) attribute{
    NSFetchRequest *requestTodos = [[NSFetchRequest alloc]initWithEntityName:@"ToDo"];
    NSLocale* currentLocale = [NSLocale currentLocale];
    NSDate *currentTime = [[NSDate alloc]init];
    [currentTime descriptionWithLocale:currentLocale];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/YYYY"];
    NSString *today = [NSString stringWithFormat:@"%@",[formatter stringFromDate:currentTime]];
    switch(attribute){
        case 0:
            requestTodos.predicate = [NSPredicate predicateWithFormat:@"state == 1"];
            break;
        case 1:
            requestTodos.predicate = [NSPredicate predicateWithFormat:@"state == 0 AND (dueDate >= %@ OR dueDate == nil)",today];
            break;
        case 2:
           requestTodos.predicate = [NSPredicate predicateWithFormat:@"state == 0 AND dueDate < %@",today];
            break;
        case 3:
            break;
        case 4:
           requestTodos.predicate = [NSPredicate predicateWithFormat:@"state == 1 AND doneDate == %@",today];
            break;
        case 5:
            requestTodos.predicate = [NSPredicate predicateWithFormat:@"state == 0 AND dueDate == %@",today];
            break;
            
    }
    NSError *error = nil;
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
 Definiamo le label all'interno delle card recuperando le icone corrette
 */

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cardCell";
    CardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
     [self fetchDataWithAttribute:indexPath.row];
    cell.textLabel.text =[NSString stringWithFormat:@"%@%lu", [nomi objectAtIndex:indexPath.row],(unsigned long)_todos.count];
    switch (indexPath.row) {
        
        case 0:
            cell.icon.image = [UIImage imageNamed: @"ChampionIcon"];
            break;
        case 1:
            cell.icon.image = [UIImage imageNamed: @"TodayUndoIcon"];
            break;
        case 2:
            cell.icon.image = [UIImage imageNamed: @"SadIcon"];
            break;
        case 3:
            cell.icon.image = [UIImage imageNamed: @"AllTodoIcon"];
            break;
        case 4:
            cell.icon.image = [UIImage imageNamed: @"ChampionIcon"];
            break;
        case 5:
            cell.icon.image = [UIImage imageNamed: @"TodayUndoIcon"];
            break;
    }
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return nomi.count;
}

/*
 Definiamo la dimensione di una cella all'interno della collectionview in modo tale da renderla
 quadrata e per averne due per riga
 */

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(CGRectGetWidth(collectionView.frame)/2.1, (CGRectGetWidth(collectionView.frame))/2.1);
}




@end
