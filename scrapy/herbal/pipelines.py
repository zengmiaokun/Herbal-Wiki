# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://doc.scrapy.org/en/latest/topics/item-pipeline.html
# import pymysql
import time

class HerbalPipeline(object):

    def process_item(self, item, spider):
        log=open("error.log","a")
        try:
            if len(item) > 2:
                for i in item:
                    print(i + ":" + item[i])
                print("\n")
            else:
                log.write(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time())) + \
                "\n" + item ["名称"]+ "内容为空，请检查异常原因。\n\n")
            return item
        except TypeError:
            log.write(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time())) + \
            "\n" + item ["名称"]+ "爬取异常，请检查错误原因。\n\n")
        
