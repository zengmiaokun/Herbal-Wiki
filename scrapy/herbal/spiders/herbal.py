# -*- coding: utf-8 -*-
import scrapy
from copy import deepcopy
#from scrapy_redis.spiders import RedisSpider

import re



class JdSpider(scrapy.Spider):
# class JdSpider(RedisSpider):
    name = 'herbal'
    allowed_domains = ['gushiwen.org']
    start_urls = ['https://www.gushiwen.org/guwen/bencao.aspx']

    def parse(self, response):
        span_list = response.xpath("//div[@class='bookcont']/div[last()]/span")    #大分类列表

        for span in span_list:
            link = span.xpath("./a/@href").extract_first()
            path = re.findall(re.compile(r'.org(.+)'), link)[0]
            headers = {
                'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3',
                'Accept-Language': 'zh-CN,zh;q=0.9,en-US;q=0.8,en;q=0.7',
                'authority': 'so.gushiwen.org',
                'scheme': 'https',
                'cache-control': 'max-age=0',
                'upgrade-insecure-requests': 1,
                'accept-encoding': 'gzip, deflate, br',
                'path': path,
                'referer': 'https://www.gushiwen.org/guwen/bencao.aspx',
                'user-agent': 'Mozilla/5.0 (Windows NT 10.0; win64; x64) AppleWebKit/537.36 (KHTML, likeGecko) Chrome/75.0.3738.0 Safari/537.36 Edg/75.0.107.0'
            }
            yield scrapy.Request(
                link,
                callback=self.parse_herbal_list,
                headers=headers
            )

    def parse_herbal_list(self, response):
        item = {}
        item["纲"] =response.xpath("//h1/span/b/text()").extract_first().split('·')[0]
        item["名称"] =response.xpath("//h1/span/b/text()").extract_first().split('·')[1]
        p_list=response.xpath("//div[@class='contson']/p")
        for p in p_list:
            item[p.xpath("./strong/text()").extract_first()]=p.xpath("./text()").extract_first()
        yield item
      