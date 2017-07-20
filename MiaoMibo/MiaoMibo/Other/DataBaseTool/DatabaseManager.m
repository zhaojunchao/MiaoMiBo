

#import "DatabaseManager.h"
#import "FMDatabase.h"
#import <objc/runtime.h>

static FMDatabase *fmdb = nil;

@implementation DatabaseManager

- (instancetype)init{
    if (self = [super init]) {
        
        static dispatch_once_t oneToken;
        dispatch_once(&oneToken, ^{
            NSString *document = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            NSString *filePath = [document stringByAppendingPathComponent:@"database.sqlite"];
            NSLog(@"数据库文件地址%@",document);
            fmdb = [FMDatabase databaseWithPath:filePath];
            
        });
    }
    return self;
}

+ (instancetype)shareDatabaseManager{
    return [[DatabaseManager alloc]init];
}


- (BOOL)creatTable:(Class)cls tableName:(NSString*)tbName{
    
    NSArray *names = [self getModelAllProperty:cls];
    NSMutableString *sql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('id' INTEGER PRIMARY KEY AUTOINCREMENT,",tbName];
    
    for (NSDictionary *dic in names) {
        NSString *name = dic[@"name"];
        NSString *type = dic[@"type"];
        [sql appendString:[NSString stringWithFormat:@"'%@' %@ ,",name,type]];
    }
    NSString *realSql = [sql substringToIndex:sql.length-1];
    realSql = [realSql stringByAppendingString:@");"];
    
    NSLog(@"创建表格: %@",realSql);
    
    [fmdb open];
    BOOL result = [fmdb executeUpdate:[realSql copy]];
    NSLog(@"创建表格:%@",result ? @"成功":@"失败");
    [fmdb close];
    return result;
}


- (BOOL)insert:(id)model tableName:(NSString*)tbName{
    
    NSArray *array = [self getModelAllProperty:[model class]];
    
    NSMutableString *propertyStr = [[NSMutableString alloc]init];
    NSMutableString *valuesStr = [[NSMutableString alloc]init];
    
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dic = array[i];
        [propertyStr appendString:[dic objectForKey:@"name"]];
        [valuesStr appendFormat:@"'%@'",[model valueForKey:[dic objectForKey:@"name"]]];
        
        if (i < array.count - 1){
            [propertyStr appendString:@","];
            [valuesStr appendString:@","];
        }
    }
    NSMutableString *sql = [NSMutableString stringWithFormat:@"INSERT INTO %@ (%@) values (%@)",tbName,propertyStr ,valuesStr];
    NSLog(@"添加数据 : %@",sql);
    [fmdb open];
    BOOL result = [fmdb executeUpdate:[sql copy]];
    [fmdb close];
    NSLog(@"添加数据:%@",result ? @"成功":@"失败");
    
    return result;
}


- (BOOL)update:(id)model tableName:(NSString*)tbName where:(NSString*)str{
    NSArray *array = [self getModelAllProperty:[model class]];
    NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE %@ SET ",tbName];
    
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dic = array[i];
        NSString *pro = [dic objectForKey:@"name"];
        [sql appendFormat:@"%@ = '%@'",pro,[model valueForKey:pro]];
        if (i < array.count - 1){
            [sql appendString:@","];
        }
    }
    
    [sql appendFormat:@" where %@",str];
    
    NSLog(@"修改数据 : %@",sql);
    [fmdb open];
    BOOL result = [fmdb executeUpdate:[sql copy]];
    [fmdb close];
    NSLog(@"更新数据:%@",result ? @"成功":@"失败");
    return result;
}

- (BOOL)deleteTableName:(NSString*)tbName where:(NSString*)str{
//    NSString *sql = [NSString stringWithFormat:@"delete from %@ where userId = '%@'",tbName,str];
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@",tbName,str];
    NSLog(@"删除数据 : %@",sql);
    [fmdb open];
    BOOL result = [fmdb executeUpdate:sql];
    [fmdb close];
    NSLog(@"更新数据:%@",result ? @"成功":@"失败");
    return result;
}


- (BOOL)deleteALLTableName:(NSString*)tbName{
    NSString *sql = [NSString stringWithFormat:@"delete * from %@",tbName];
    NSLog(@"删除数据 : %@",sql);
    [fmdb open];
    BOOL result = [fmdb executeUpdate:sql];
    [fmdb close];
    NSLog(@"更新数据:%@",result ? @"成功":@"失败");
    return result;
}


- (NSArray*)select:(Class)model tableName:(NSString*)tbName where:(NSString*)str{
//    NSString *sql = [NSString stringWithFormat:@"select * from %@ where userId = '%@'",tbName,str];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@",tbName,str];
    NSArray *array = [self getModelAllProperty:[model class]];
    [fmdb open];
    NSLog(@"查询数据 : %@",sql);
    FMResultSet *set = [fmdb executeQuery:sql];
    NSMutableArray *allArray = [[NSMutableArray alloc]init];
    while ([set next]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dic1 = array[i];
            NSString *pro = [dic1 objectForKey:@"name"];
            [dic setValue:[set stringForColumn:pro] forKey:pro];
        }
        [allArray addObject:dic];
    }
    
    [set close];
    [fmdb close];
    return [allArray copy];
}

- (NSArray*)selectALL:(Class)model tableName:(NSString*)tbName {
    NSString *sql = [NSString stringWithFormat:@"select * from %@ ",tbName];
    NSArray *array = [self getModelAllProperty:[model class]];
    [fmdb open];
    NSLog(@"查询数据 : %@",sql);
    FMResultSet *set = [fmdb executeQuery:sql];
    NSMutableArray *allArray = [[NSMutableArray alloc]init];
    while ([set next]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dic1 = array[i];
            NSString *pro = [dic1 objectForKey:@"name"];
            [dic setValue:[set stringForColumn:pro] forKey:pro];
        }
        [allArray addObject:dic];
    }
    
    [set close];
    [fmdb close];
    return [allArray copy];
}

#pragma mark --- 辅助方法 ---

/**
 *  获取 model 类全部的属性和属性类型
 *
 *  @param cls model 类 class
 *
 *  @return 返回 model 的属性和属性类型
 */
- (NSArray *)getModelAllProperty:(Class)cls{
    
    unsigned int count = 0;
    objc_property_t *propertys = class_copyPropertyList(cls, &count);
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        
        objc_property_t property = propertys[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        NSString *type = [self getPropertyAttributeValue:property name:@"T"];
        
        if ([type isEqualToString:@"q"]||[type isEqualToString:@"i"]) {
            type = @"INTEGER";
        }else if([type isEqualToString:@"f"] || [type isEqualToString:@"d"]){
            type = @"FLOAT";
        }else{
            type = @"TEXT";
        }
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:propertyName , @"name",type , @"type", nil];
        
        [array addObject:dic];
        
    }
    free(propertys);
    return array.copy;
}

/**
  *  获取属性的特征值
  */
- (NSString*)getPropertyAttributeValue:(objc_property_t) pro name:(NSString*)name{
    unsigned int count = 0;
    objc_property_attribute_t *attributes = property_copyAttributeList(pro, &count);
    
    for (int i = 0 ; i < count; i++) {
        objc_property_attribute_t attribute = attributes[i];
        if (strcmp(attribute.name, name.UTF8String) == 0) {
            return [NSString stringWithCString:attribute.value encoding:NSUTF8StringEncoding];
        }
    }
    free(attributes);
    return nil;
}



/**
 *  判断是否存在表
 *
 *  @param tableName 表名
 *
 *  @return 是否存在
 */
- (BOOL) isTableOK:(NSString *)tableName
{
     [fmdb open];
    
    FMResultSet *rs = [fmdb executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    
   
    
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        
        if (0 == count)
        {
            [fmdb close];
            
            return NO;
        }
        else
        {
            [fmdb close];
            return YES;
        }
    }
    [fmdb close];
    return NO;
}


@end
