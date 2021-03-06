<%--
  Created by IntelliJ IDEA.
  User: zengm
  Date: 2019/5/28
  Time: 21:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
  <link rel="shortcut icon" href="./images/favicon.ico" type="image/x-icon" />
  <title>本草百科</title>
  <link rel="stylesheet" href="./css/style.css">
  <script src="./layui/layui.js"></script>
  <script src="./js/swiper.min.js"></script>
</head>

<body>
<!-- 导航栏 -->
<div class="nav">
  <ul class="layui-nav">
    <li class="layui-nav-item">
      <a href="">收藏本<span class="layui-badge">9</span></a>
    </li>
    <li class="layui-nav-item">
      <a href=""><img src="./images/user.jpg" class="layui-nav-img">我</a>
      <dl class="layui-nav-child">
        <dd><a href="javascript:;">修改信息</a></dd>
        <dd><a href="javascript:;">安全管理</a></dd>
        <dd><a href="javascript:;">退出</a></dd>
      </dl>
    </li>
  </ul>
</div>
<script>
  //注意：导航 依赖 element 模块，否则无法进行功能性操作
  layui.use(['element', 'jquery'], function() {
    $ = layui.$;
    var element = layui.element;
  });

  function show() {
    $("#focus_shade").fadeOut(300);
  }

  function fade() {
    $("#focus_shade").fadeIn(300);
  }
</script>
<!-- Swiper -->
<div class="swiper-container">
  <div class="swiper-wrapper">
    <div class="swiper-slide info">
      <!-- 搜索框 -->
      <form action="./search.jsp" class="fly-extend-banner-search search" target="_blank">
        <input type="hidden" name="field" value="all">
        <div class="layui-inline"> <input onBlur="show()" onFocus="fade()" required placeholder="请输入要查询的中草药" name="kw" autocomplete="off" value="" class="layui-input"></div><button class="layui-btn"><i
              class="layui-icon layui-icon-search"></i></button>
      </form>
      <div id="focus_shade"></div>

      <p>
        <i class="layui-icon layui-icon-down down-arrow"></i>
      </p>
    </div>
    <div class="swiper-slide book">
      <p>
        &nbsp;&nbsp;&nbsp;&nbsp;《本草纲目》，本草著作，52卷。明代李时珍(东璧)撰于嘉靖三十一年(1552年)至万历六年(1578年)，稿凡三易。 此书采用“目随纲举”编写体例，故以“纲目”名书。
      </p>
    </div>
    <div class="swiper-slide author">
      <p>李时珍（1518—1593），字东璧，晚年自号濒湖山人，湖北蕲春县蕲州镇东长街之瓦屑坝（今博士街）人，明代著名医药学家。后为楚王府奉祠正、皇家太医院判，去世后明朝廷敕封为“文林郎”。</p>
    </div>
  </div>
  <div class="swiper-pagination"></div>
</div>
<!-- Initialize Swiper -->
<script>
  var swiper = new Swiper('.swiper-container', {
    direction: 'vertical',
    slidesPerView: 1,
    followFinger: false,
    speed: 800,
    mousewheel: true,
    pagination: {
      el: '.swiper-pagination',
      clickable: true,
    },
    on: {
      init: function(swiper) {
        slide = this.slides.eq(0);
        slide.addClass('ani-slide');
      },
      transitionStart: function() {
        for (i = 0; i < this.slides.length; i++) {
          slide = this.slides.eq(i);
          slide.removeClass('ani-slide');
        }
      },
      transitionEnd: function() {
        slide = this.slides.eq(this.activeIndex);
        slide.addClass('ani-slide');

      },
    }
  });
</script>
</body>

</html>
