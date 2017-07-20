

#import <Foundation/Foundation.h>

@interface DatabaseManager : NSObject

+ (instancetype)shareDatabaseManager;
 /**
  *  创建表格
  *
  *  @param cls    model 类
  *  @param tbName 表名
  *
  *  @return 创建表格是否成功
  */
- (BOOL)creatTable:(Class)cls tableName:(NSString*)tbName ;

/**
 *  判断是否存在表
 *
 *  @param tableName 表名
 *
 *  @return 是否存在
 */
- (BOOL) isTableOK:(NSString *)tableName;

 /**
  *  向表格插入数据
  *
  *  @param model  数据模型与数据库表格对应
  *  @param tbName 要操作的表名
  *
  *  @return 添加是否成功
  */
 - (BOOL)insert:(id)model tableName:(NSString*)tbName;
 /**
  *  更新数据
  *
  *  @param tbName 要操作的表名
  *  @param model 数据模型与数据库表格对应
  *  @param str   更新操作查要更新的数据的条件
  *
  *  @return 更新是否成功
  */
- (BOOL)update:(id)model tableName:(NSString*)tbName where:(NSString*)str;
 /**
  *  删除数据
  *
  *  @param tbName 要删除数据的表名
  *  @param str    要删除的数据的查找条件
  *
  *  @return 删除是否成功
  */
 - (BOOL)deleteTableName:(NSString*)tbName where:(NSString*)str;

/**
 *  删除表中全部数据
 *
 *  @param tbName 要操作的表名
 *
 *  @return 删除是否成功
 */
- (BOOL)deleteALLTableName:(NSString*)tbName;

 /**
  *  查询数据
  *
  *  @param model  数据模型与数据库表格对应
  *  @param tbName 要操作的表名
  *  @param str    删除操作查要删除的数据的条件
  *
  *  @return 查询结果 (数组每一项为字典)
  */


- (NSArray*)select:(Class)model tableName:(NSString*)tbName where:(NSString*)str;
/**
  *  查询全部数据
  *
  *  @param model  数据模型与数据库表格对应
  *  @param tbName 要操作的表名
  *
  *  @return 查询结果 (数组每一项为字典)
*/
- (NSArray*)selectALL:(Class)model tableName:(NSString*)tbName;

@end
