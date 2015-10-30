//
//  ViewController.m
//  搜索searchBar
//
//  Created by weihaijuan on 15/10/27.
//  Copyright © 2015年 weihaijuan. All rights reserved.
//

#import "ViewController.h"
#import "NSString+HanziTransformFirstChar.h"
#import "PinYinForObjc.h"
#import "chineseInclude.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UISearchBar *_searchBar;
    UITableView *_tableView;
    UISearchDisplayController *_searchDisplay;
    NSMutableArray *_cityArray;
    NSMutableArray *_indexArray;
    NSMutableDictionary *_indexDic;
    NSMutableArray *_searchArray;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_tableView];
    
    _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    _searchBar.delegate=self;
    _searchBar.placeholder=@"搜索";
    _tableView.tableHeaderView=_searchBar;
    
    _searchDisplay=[[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    _searchDisplay.searchResultsDataSource=self;
    _searchDisplay.searchResultsDelegate=self;

    _tableView.sectionIndexBackgroundColor=[UIColor clearColor];
    
    NSString *path=[[NSBundle mainBundle]pathForResource:@"city.json" ofType:nil];
    NSData *data=[NSData dataWithContentsOfFile:path];
    NSDictionary *rootDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *citiesArray=rootDic[@"city"];
    
    _cityArray=[NSMutableArray array];
    for (NSDictionary *dic in citiesArray)
    {
        [_cityArray addObject:dic[@"province_name"]];
    }
    
    
    _indexArray=[NSMutableArray array];
    _indexDic=[NSMutableDictionary dictionary];
    for (char character='A'; character<='Z'; character++)
    {
        [_indexArray addObject:[NSString stringWithFormat:@"%c",character]];
        NSMutableArray *array=[NSMutableArray array];
        [_indexDic setObject:array forKey:[NSString stringWithFormat:@"%c",character]];
    }
    
    for (NSString *city in _cityArray)
    {
        NSString *firstWord=[NSString firstCharFromHanzi:city];
        NSMutableArray *array=[_indexDic objectForKey:firstWord];
        [array addObject:city];
    }
    
    for (NSString *firstWord in _indexArray)
    {
        NSArray *array=[_indexDic objectForKey:firstWord];
        if (array.count==0)
        {
            [_indexDic removeObjectForKey:firstWord];
        }
    }
    
    NSArray *sorted=[_indexDic.allKeys sortedArrayUsingSelector:@selector(compare:)];
    _indexArray=[NSMutableArray arrayWithArray:sorted];
    
}
#pragma mark UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _searchArray=[NSMutableArray array];
    if (_searchBar.text.length>0&&![chineseInclude isIncludeChineseInStr:_searchBar.text])
    {
        for (int i=0; i<_cityArray.count; i++)
        {
            if ([chineseInclude isIncludeChineseInStr:_cityArray[i]])
            {
                NSString *tempPinYinStr=[PinYinForObjc chineseConvertToPinYin:_cityArray[i]];
                NSRange titleReust=[tempPinYinStr rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
                if (titleReust.length>0)
                {
                    [_searchArray addObject:_cityArray[i]];
                }
                
            }
            else
            {
                NSRange titleResult=[_cityArray[i]rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0)
                {
                    [_searchArray addObject:_cityArray[i]];
                }
            }
        }
    }
    else if (_searchBar.text.length>0&&[chineseInclude isIncludeChineseInStr:_searchBar.text])
    {
        for (NSString *tempStr in _cityArray)
        {
            NSRange titleReust=[tempStr rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
            if (titleReust.length>0)
            {
                [_searchArray addObject:tempStr];
            }
        }
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==_searchDisplay.searchResultsTableView)
    {
        return 1;
    }
    else
        return _indexArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_searchDisplay.searchResultsTableView)
    {
        return _searchArray.count;
    }
    else
    {
        NSString *key=[_indexArray objectAtIndex:section];
        NSArray *array=[_indexDic objectForKey:key];
        return array.count;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==_searchDisplay.searchResultsTableView)
    {
        return nil;
    }
    else
    {
        NSString *key=[_indexArray objectAtIndex:section];
        return key;
    }
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView==_searchDisplay.searchResultsTableView)
    {
        return nil;
    }
    return _indexArray;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (tableView==_searchDisplay.searchResultsTableView)
    {
        cell.textLabel.text=_searchArray[indexPath.row];
    }
    else
    {
        NSString *key=[_indexArray objectAtIndex:indexPath.section];
        NSArray *array=[_indexDic objectForKey:key];
        cell.textLabel.text=array[indexPath.row];
    }

    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
