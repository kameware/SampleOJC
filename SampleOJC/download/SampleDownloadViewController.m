//
//  SampleDownloadViewController.m
//  SampleOJC
//
//  Created by mineharu on 2016/09/11.
//  Copyright © 2016年 Mineharu. All rights reserved.
//

#import "SampleDownloadViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface SampleDownloadViewController ()


@property NSURL *downloadFilePath;

@property NSInteger count;

@end

@implementation SampleDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.count = 0;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapDownloadBtn:(id)sender {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    for (NSInteger i = 0; i < 30; i++) {
        [self nsDownload];
    }
}
- (IBAction)tapDeleteBtn:(id)sender {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self.downloadFilePath path]]) {
        [fileManager removeItemAtPath:[self.downloadFilePath path] error:nil];
    }
}

- (void)afDownlaod
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"aaa"];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *url = [NSURL URLWithString:@"http://hapinaru.com/header.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setValue:@"ABCD" forHTTPHeaderField:@"1234"];
    //    [request setHTTPBody:[[NSData alloc] initWithBase64EncodedString:@"aaaa" options:nil]];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        [NSThread sleepForTimeInterval:3.0];
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        self.downloadFilePath = [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:[self.downloadFilePath path]]) {
            [fileManager removeItemAtPath:[self.downloadFilePath path] error:nil];
        }
        return self.downloadFilePath;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        self.downloadFilePath = filePath;
        NSLog(@"File downloaded to : %@", [[NSString alloc] initWithContentsOfURL:filePath encoding:NSUTF8StringEncoding error:nil]);
    }];
    [downloadTask resume];}

- (void)nsDownload
{
    NSURL *url = [NSURL URLWithString:@"http://hapinaru.com/header.php"];
    NSURLSessionConfiguration *configration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"aa"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configration delegate:self delegateQueue:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setValue:@"ABCD" forHTTPHeaderField:@"1234"];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    [task resume];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
//    NSLog(@"Session %@ download task %@ finished downloading to URL %@\n",
//          session, downloadTask, location);
    
    NSData *data = [NSData dataWithContentsOfURL:location];
    NSLog(@"count : %ld",(long)self.count);
//    NSLog(@"responce : %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
//    if (self.count < 10) {
        self.count++;
//        [self nsDownload];
//    }
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
}


@end
