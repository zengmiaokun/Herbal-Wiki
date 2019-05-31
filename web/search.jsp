<%--
  Created by IntelliJ IDEA.
  User: zengm
  Date: 2019/5/28
  Time: 22:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.*, java.sql.*, javax.sql.*, javax.naming.*"%>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
    <link rel="shortcut icon" href="./images/favicon.ico" type="image/x-icon" />
    <title>搜索结果</title>
    <link rel="stylesheet" href="./css/search.css">
    <script src="./layui/layui.js"></script>
    <script src="./font/iconfont.js"></script>
</head>
<%
//    获取参数
    String field = null, kw = null;
    int  pages = 1, limit = 24;
    if (request.getParameter("page") != null && request.getParameter("page") != "")
        pages = Integer.parseInt(request.getParameter("page"));
    if (request.getParameter("limit") != null && request.getParameter("limit") != "")
        limit = Integer.parseInt(request.getParameter("limit"));
    if(request.getParameter("field") != null && request.getParameter("field") != "")
        field = request.getParameter("field");
    else
    {
        response.sendRedirect(request.getContextPath()+"/index.jsp");
        return;
    }
    if(request.getParameter("kw") != null && request.getParameter("kw") != "")
        kw = request.getParameter("kw");
    else
    {
        response.sendRedirect(request.getContextPath()+"/index.jsp");
        return;
    }
//    打开连接池
    Context initContext = new InitialContext();
    Context envContext  = (Context)initContext.lookup("java:/comp/env");
    DataSource ds = (DataSource)envContext.lookup("jdbc/herbal");
    Connection conn = null, countConn = null;
    PreparedStatement psmt = null, countPsmt = null;
    ResultSet rs = null, countRs= null;
    String name = null, fieldName = null, image = null;
    int id = 0, count = 0;
    try {
        conn = ds.getConnection();
        countConn = ds.getConnection();
        switch (field) {
            case "name":
                fieldName = "名称";
                countPsmt = countConn.prepareStatement("SELECT id, 名称, 图片 FROM herbal WHERE 名称 LIKE CONCAT('%', ?,'%') OR 释名 LIKE CONCAT('%', ?,'%')");
                psmt = conn.prepareStatement("SELECT id, 名称, 图片 FROM herbal WHERE 释名 LIKE CONCAT('%', ?,'%') LIMIT ?,?");
                psmt.setString(1, kw);
                psmt.setString(2, kw);
                countPsmt.setString(1,kw);
                countPsmt.setString(2,kw);
                psmt.setInt(3, (pages - 1) * limit);
                psmt.setInt(4, limit);
                break;
            case "functions":
                fieldName = "主治";
                countPsmt = countConn.prepareStatement("SELECT id, 名称, 图片 FROM herbal WHERE 主治 LIKE CONCAT('%', ?,'%')");
                psmt = conn.prepareStatement("SELECT id, 名称, 图片 FROM herbal WHERE 主治 LIKE CONCAT('%', ?,'%') LIMIT ?,?");
                psmt.setString(1, kw);
                countPsmt.setString(1,kw);
                psmt.setInt(2, (pages - 1) * limit);
                psmt.setInt(3, limit);
                break;
            case "class":
                fieldName = "所属纲";
                countPsmt = countConn.prepareStatement("SELECT id, 名称, 图片 FROM herbal WHERE 纲 LIKE CONCAT('%', ?,'%')");
                psmt = conn.prepareStatement("SELECT id, 名称, 图片 FROM herbal WHERE 纲 LIKE CONCAT('%', ?,'%') LIMIT ?,?");
                psmt.setString(1, kw);
                countPsmt.setString(1,kw);
                psmt.setInt(2, (pages - 1) * limit);
                psmt.setInt(3, limit);
                break;
            default:
                fieldName = "全部";
                countPsmt = countConn.prepareStatement("SELECT id, 名称, 图片 FROM herbal WHERE 主治 LIKE CONCAT('%', ?,'%') OR 纲 LIKE CONCAT('%', ?,'%') OR 名称 LIKE CONCAT('%', ?,'%') OR 释名 LIKE CONCAT('%', ?,'%')");
                psmt = conn.prepareStatement("SELECT id, 名称, 图片 FROM herbal WHERE 主治 LIKE CONCAT('%', ?,'%') OR 纲 LIKE CONCAT('%', ?,'%') OR 名称 LIKE CONCAT('%', ?,'%') OR 释名 LIKE CONCAT('%', ?,'%') LIMIT ?,?");
                psmt.setString(1, kw);
                psmt.setString(2, kw);
                psmt.setString(3, kw);
                psmt.setString(4, kw);
                countPsmt.setString(1,kw);
                countPsmt.setString(2,kw);
                countPsmt.setString(3,kw);
                countPsmt.setString(4,kw);
                psmt.setInt(5, (pages - 1) * limit);
                psmt.setInt(6, limit);
        }
        countRs = countPsmt.executeQuery();
        rs = psmt.executeQuery();

        countRs.last();
        count = countRs.getRow();
%>


<body>
<div class="nav-box">
    <!-- 导航栏 -->
    <div class="header layui-container layui-header">
        <div class="layui-main">
            <a class="index" href="./index.jsp">首页</a>
            <form action="search.jsp" class="fly-extend-banner-search layui-form search" target="">
                <div class="layui-form-item">
                    <div class="field-select layui-input-inline">
                        <select name="field" id="">
                            <option value="all">全部</option>
                            <option value="name">名称</option>
                            <option value="functions">主治</option>
                            <option value="class">所属纲</option>
                        </select>
                    </div>
                    <div class="field-text layui-input-inline">
                        <input type="text" name="kw" required lay-verify="required" placeholder="<%=kw%>" autocomplete="off" class="layui-input">
                    </div>
                    <div class="submit">
                        <button class="layui-btn" lay-submit lay-filter="kw">
                            <i class="layui-icon layui-icon-search"></i>
                        </button>
                    </div>
                </div>
            </form>

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

    </div>
</div>
<!-- 面包屑导航 -->
<div class="bread-nav">
    <div class="layui-container">
            <span class="layui-breadcrumb">
                <a href="./index.jsp">首页</a>
                <a href="javascript: void(0);"><cite>搜索结果</cite></a>
              </span>
    </div>
</div>

<div class="result-box">
    <div class="layui-container">
        <div class="result-summary">
            共搜索到
            <span><%=count%></span> 种
            <span><%=fieldName%></span> 字段中包含
            <span><%=kw%></span> 的中草药
        </div>
        <div class="result-list">
            <div class="layui-row">
            <%
//                读取数据
                while (rs.next())
                {
                    id = rs.getInt("id");
                    name = rs.getString("名称");
                    if(rs.getString("图片")!=null)
                        image = rs.getString("图片");
                    else
                        image = "./images/herbal/default.jpg";
            %>
                <div class="result-card layui-col-md3 layui-col-sm4 layui-col-xs6">
                    <div class="card-content">
                        <a href="./detail.jsp?id=<%=id%>" target="_blank">
                            <div class="herbal-img">
                                <img src="<%=image%>" alt="">
                            </div>
                            <h2><%=name%></h2>
                        </a>
                    </div>
                </div>

        <%
                    }
            } catch (Exception e) {
                throw e;
            } finally {
                try {
                    if (psmt != null) psmt.close();
                    if (conn != null) conn.close();
                } catch (Exception e) {
                    throw e;
                }
            }
        %>
            </div>
        </div>
    </div>
    <div id="page"></div>
</div>
<script>
    layui.use(['element', 'form', "laypage"], function() {
        var element = layui.element,
            form = layui.form,
            laypage = layui.laypage;
        form.render();
        laypage.render({
            elem: 'page'
            ,count: <%=count%>
            ,limit: 24
            ,theme: '#d2691e'
            ,layout: ['count', 'prev', 'page', 'next', 'limit', 'refresh', 'skip']
            ,curr: <%=pages%> //获取起始页
            ,jump: function(obj, first){
                //obj包含了当前分页的所有参数，比如：

                console.log(obj.curr); //得到当前页，以便向服务端请求对应页的数据。
                console.log(obj.limit); //得到每页显示的条数


                //首次不执行
                if(!first){
                    //do something
                    window.location.href="./search.jsp?field=<%=field%>&kw=<%=kw%>&page=" + obj.curr + "&limit=" + obj.limit;
                }
            }
        });
    });
</script>
</body>

</html>
