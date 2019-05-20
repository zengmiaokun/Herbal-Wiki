# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://doc.scrapy.org/en/latest/topics/item-pipeline.html


import time
import pymysql.cursors

class HerbalPipeline(object):

    def __init__(self):
        # 连接数据库
        self.connect = pymysql.connect(
            host='192.168.1.1',  # 数据库地址
            port=3306,  # 数据库端口
            db='herbal_wiki',  # 数据库名
            user='mango',  # 数据库用户名
            passwd='mango0905',  # 数据库密码
            charset='utf8',  # 编码方式
            use_unicode=True)
        # 通过cursor执行增删查改
        self.cursor = self.connect.cursor()

    def process_item(self, item, spider):
        log=open("error.log","a")
        try:
            if len(item) > 2:
                self.cursor.execute("INSERT INTO herbal (%s) VALUES ('%s')" %(",".join(list(item.keys())),"','".join(list(item.values()))))
                self.connect.commit()
                return item
            else:
                log.write(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time())) + \
                "\n" + item ["名称"]+ "内容为空，请检查异常原因。\n\n")
            return item
        except TypeError:
            log.write(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time())) + \
            "\n" + item ["名称"]+ "爬取异常，请检查错误原因。\n\n")
        except pymysql.err.InternalError:
            for i in item:
                print(i + ":" + item[i])
                print("\n")
