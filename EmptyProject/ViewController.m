//
//  ViewController.m
//  EmptyProject
//
//  Created by jayaprada on 11/04/16.
//  Copyright © 2016 jayaprada. All rights reserved.
//

#import "ViewController.h"

#import "MyDocument.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSString *filePath;
}
@property(strong,nonatomic)NSMetadataQuery *query;
@property (weak, nonatomic) IBOutlet UILabel *loadingIndicatorLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingBackupIndicator;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@property(strong,nonatomic)NSMutableArray *backups;
@property(strong,nonatomic) NSString *fileNameToDownLoad;
- (IBAction)uploadBtnTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *showFilesBtn;
- (IBAction)showFilesBtnTapped:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Check if reqd file is present in doc directory
    
    
    // If not Save a file to documents Directory
    self.fileNameToDownLoad =@"public.png";
    [self SaveDataToDocDir];
    self.backups = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - First save data to local directory

-(void)SaveDataToDocDir{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, self.fileNameToDownLoad];
    NSLog(@"filePath %@", filePath);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) { // if file is not exist, create it.
        NSString *helloStr = @"hello world";
        NSError *error;
        [helloStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }else{
        NSLog(@"File already Exists in Doc Dir");
    }
    
    if ([[NSFileManager defaultManager] isWritableFileAtPath:filePath]) {
        NSLog(@"Writable");
    }else {
        NSLog(@"Not Writable");
    }
}

#pragma mark - Upload Data to iCloud-Drive

- (IBAction)uploadBtnTapped:(id)sender {
    
    //Check if reqd file is present in iCloud-Drive
    
    //Upload that to iCloud-Drive
    
    
    
    // Let's get the root directory for storing the file on iCloud Drive
    [self rootDirectoryForICloud:^(NSURL *ubiquityURL) {
        NSLog(@"1. ubiquityURL = %@", ubiquityURL);
        if (ubiquityURL) {
            //            ubiquityURL = [ubiquityURL URLByAppendingPathComponent:localURL.lastPathComponent];
            
            // We also need the 'local' URL to the file we want to store
            NSURL *localURL = [self localPathForResource:@"public" ofType:@"png"];
            NSLog(@"2. localURL = %@", localURL);
            
            // Now, append the local filename to the ubiquityURL
            ubiquityURL = [ubiquityURL URLByAppendingPathComponent:localURL.lastPathComponent];
            NSLog(@"3. ubiquityURL = %@", ubiquityURL);
            
            // And finish up the 'store' action
            NSError *error;
            if (![[NSFileManager defaultManager] setUbiquitous:YES itemAtURL:localURL destinationURL:ubiquityURL error:&error]) {
                NSLog(@"Error occurred: %@", error);
                
                /*
                 Error Domain=NSCocoaErrorDomain Code=516 "The file “ipad_user_guide.pdf” couldn’t be saved in the folder “EmptyProject” because a file with the same name already exists." UserInfo={NSURL=file:///private/var/mobile/Library/Mobile%20Documents/iCloud~com~virinchi~EmptyProject/Documents/ipad_user_guide.pdf, NSUnderlyingError=0x12fe4ef90 {Error Domain=NSPOSIXErrorDomain Code=17 "File exists"}}
                 */
            }
        }
        else {
            NSLog(@"Could not retrieve a ubiquityURL");
        }
    }];
    
}

- (void)rootDirectoryForICloud:(void (^)(NSURL *))completionHandler {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *rootDirectory = [[[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil]URLByAppendingPathComponent:@"Documents"];
        
        if (rootDirectory) {
            //            if (![[NSFileManager defaultManager] fileExistsAtPath:rootDirectory.path isDirectory:nil]) {
            NSLog(@"Create directory");
            [[NSFileManager defaultManager] createDirectoryAtURL:rootDirectory withIntermediateDirectories:YES attributes:nil error:nil];
            //             }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(rootDirectory);
        });
    });
}

- (NSURL *)localPathForResource:(NSString *)resource ofType:(NSString *)type {
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *resourcePath = [[documentsDirectory stringByAppendingPathComponent:resource] stringByAppendingPathExtension:type];
    return [NSURL fileURLWithPath:resourcePath];
}






#pragma mark - Download Data from iCloud-Drive


-(void)getDataFromiCloud{
    self.query = [[NSMetadataQuery alloc] init];
    [self.query setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
    NSPredicate *pred = [NSPredicate predicateWithFormat: @"%K LIKE '*'", NSMetadataItemFSNameKey];
    [self.query setPredicate:pred];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queryDidFinishGathering:)
                                                 name:NSMetadataQueryDidFinishGatheringNotification
                                               object:self.query];
    
    [self.query startQuery];
    
}

- (void)queryDidFinishGathering:(NSNotification *)notification {
    NSMetadataQuery *query = [notification object];
    [query disableUpdates];
    [query stopQuery];
    
    [self loadData:query];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidFinishGatheringNotification object:query];
    
    self.query = nil;
}
- (void)loadData:(NSMetadataQuery *)query {
    [self.backups removeAllObjects];
    for (NSMetadataItem *item in [query results]) {
        NSLog(@"Display Name %@",[item valueForAttribute:NSMetadataItemDisplayNameKey]);
        
        NSURL *documentURL = [item valueForAttribute:NSMetadataItemURLKey];
        MyDocument *document = [[MyDocument alloc] initWithFileURL:documentURL];
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                [self.backups addObject:document];
                [self.myTableView reloadData];
            }
        }];
     }
    
    
    [self.loadingBackupIndicator stopAnimating];
    self.loadingIndicatorLabel.text = [NSString stringWithFormat: @"%lu backups found", (unsigned long)[self.backups count]];
}

- (BOOL)downloadFileIfNotAvailable {
    NSNumber *isIniCloud = nil;
    
    NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    
    NSURL *file = [[ubiq URLByAppendingPathComponent:@"Documents" isDirectory:true] URLByAppendingPathComponent:self.fileNameToDownLoad];
    
    if ([file getResourceValue:&isIniCloud forKey:NSURLIsUbiquitousItemKey error:nil]) {
        // If the item is in iCloud, see if it is downloaded.
        if ([isIniCloud boolValue]) {
            NSNumber*  isDownloaded = nil;
            if ([file getResourceValue:&isDownloaded forKey:NSURLUbiquitousItemDownloadingStatusKey error:nil]) {
                if ([isDownloaded boolValue]) {
                    [self.loadingBackupIndicator stopAnimating];
                    self.loadingIndicatorLabel.text = @"Downloaded";
                    
                    
                    //                    [[NSFileManager defaultManager] copyItemAtPath:[file path] toPath:restorePath error:&theError ];
                    
                    
                    return YES;
                }
                
                NSTimer
                *loadingCheckTimer = [NSTimer timerWithTimeInterval:3.0f target:self selector:@selector(downloadFileIfNotAvailable) userInfo:nil repeats:NO];
                [[NSRunLoop currentRunLoop] addTimer: loadingCheckTimer forMode:NSDefaultRunLoopMode];
                
                return NO;
            }
        }
    }
    
    return YES;
}
-(BOOL)startDownLoadFiles:(NSString *)filenameForDownloading{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    
    if (ubiq == nil) {
        return NO;
    }
    
    NSError *theError = nil;
    
    BOOL started = [fm startDownloadingUbiquitousItemAtURL:[[ubiq URLByAppendingPathComponent:@"Documents" isDirectory:nil] URLByAppendingPathComponent:filenameForDownloading] error:&theError];
    
    NSLog(@"started download for %@ %d",filenameForDownloading, started);
    
    if (theError != nil) {
        NSLog(@"iCloud error: %@", [theError localizedDescription]);
    }
    return started;
}
- (IBAction)showFilesBtnTapped:(id)sender {
    [self getDataFromiCloud];
}

#pragma mark - UITABLEVIEWDATASOURCE


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.backups.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellIdentifier";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    // Fetch Bookmark
    MyDocument *document = [self.backups objectAtIndex:indexPath.row];
    
    // Configure Cell
    cell.textLabel.text = document.docModelObj.docName;
    cell.detailTextLabel.text =  document.docModelObj.docURl;
    cell.textLabel.text = [self.backups objectAtIndex:indexPath.row];
    return cell;
    
    
}@end
