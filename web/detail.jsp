<%--
  Created by IntelliJ IDEA.
  User: zengm
  Date: 2019/5/29
  Time: 19:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.*, java.sql.*, javax.sql.*, javax.naming.*"%>

<%
//    获取参数
    int id = 1;
    if (request.getParameter("id") != null && request.getParameter("id") != "")
        id = Integer.parseInt(request.getParameter("id"));
//    打开连接池
    Context initContext = new InitialContext();
    Context envContext  = (Context)initContext.lookup("java:/comp/env");
    DataSource ds = (DataSource)envContext.lookup("jdbc/herbal");
    Connection conn = null, editedConn = null;
    PreparedStatement psmt = null, editPsmt = null;
    ResultSet rs = null, editedRs = null;

//    读取数据

    try {
        conn = ds.getConnection();
        editedConn = ds.getConnection();
        psmt = conn.prepareStatement("SELECT * FROM herbal WHERE id = ?");
        editPsmt = editedConn.prepareStatement("SELECT * FROM herbal_edited WHERE herbal_id = ?");
        psmt.setInt(1,id);
        editPsmt.setInt(1, id);
        rs = psmt.executeQuery();
        editedRs = editPsmt.executeQuery();
        if (rs.next())
        {
%>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
    <link rel="shortcut icon" href="./images/favicon.ico" type="image/x-icon" />
    <title><%=rs.getString("名称")%></title>
    <link rel="stylesheet" href="./css/detail.css">
    <script src="./layui/layui.js"></script>
</head>
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
                            <option value="treat">主治</option>
                            <option value="class">所属纲</option>
                        </select>
                    </div>
                    <div class="field-text layui-input-inline">
                        <input type="text" name="kw" required lay-verify="required" autocomplete="off" class="layui-input">
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
                    <a href="javascript: void(0);"><cite><%=rs.getString("名称")%></cite>
            </a>
            </span>
    </div>
</div>
<!-- 中草药详情 -->
<div class="detail-box layui-container">
    <div class="layui-row">
        <div class="layui-col-sm5 layui-col-12">
            <div class="herbal-img">
                <img src="<%=rs.getString("图片") == null ? "./images/herbal/default.jpg" : rs.getString("图片")%>" alt="">
            </div>
        </div>
        <div class="layui-col-sm7 layui layui-col-12 herbal-text">
<%
            if (rs.getString("纲") != null)
                out.print("<p><span class=\"field\">纲：</span>" + rs.getString("纲") + "</p>");
            out.print("<p><span class=\"field\">名称：</span>" + rs.getString("名称") + "</p>");
            if (rs.getString("释名") != null)
                out.print("<p><span class=\"field\">释名：</span>" + rs.getString("释名") + "</p>");
            if (rs.getString("气味") != null)
                out.print("<p><span class=\"field\">气味：</span>" + rs.getString("气味") + "</p>");
            if (rs.getString("主治") != null)
                out.print("<p><span class=\"field\">主治：</span>" + rs.getString("主治") + "</p>");
            if (rs.getString("附方") != null)
                out.print("<p><span class=\"field\">附方：</span>" + rs.getString("附方") + "</p>");
            if (rs.getString("集解") != null)
                out.print("<p><span class=\"field\">集解：</span>" + rs.getString("集解") + "</p>");
            if (rs.getString("辨疑") != null)
                out.print("<p><span class=\"field\">辨疑：</span>" + rs.getString("辨疑") + "</p>");
            if (rs.getString("发明") != null)
                out.print("<p><span class=\"field\">发明：</span>" + rs.getString("发明") + "</p>");
            if (rs.getString("修治") != null)
                out.print("<p><span class=\"field\">修治：</span>" + rs.getString("修治") + "</p>");
            }
%>

        </div>
    </div>
    <a class="alter" href="javascript: edit();">
        <i class="layui-icon layui-icon-edit"></i>
    </a>
</div>

<%--编辑窗口--%>

<div class="edit-box layui-container" id="edit-box">
    <form class="layui-form" method="post" action="./update.jsp" target="_self">
        <h1>修订内容</h1>
        <input type="hidden" name="id" value="<%=id%>">
        <input type="hidden" name="image" id="image-src">
        <div class="layui-form-item">
            <label for="">释名</label>
            <div class="layui-input-inline">
                <textarea placeholder="请输入内容" name="explain" class="layui-textarea"></textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <label for="">气味</label>
            <div class="layui-input-inline">
                <textarea placeholder="请输入内容" name="smell" class="layui-textarea"></textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <label for="">主治</label>
            <div class="layui-input-inline">
                <textarea placeholder="请输入内容" name="functions" class="layui-textarea"></textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <label for="">附方</label>
            <div class="layui-input-inline">
                <textarea placeholder="请输入内容" name="accessoryParty" class="layui-textarea"></textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <label for="">集解</label>
            <div class="layui-input-inline">
                <textarea placeholder="请输入内容" name="collectedExplanations" class="layui-textarea"></textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <label for="">辨疑</label>
            <div class="layui-input-inline">
                <textarea placeholder="请输入内容" name="question" class="layui-textarea"></textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <label for="">发明</label>
            <div class="layui-input-inline">
                <textarea placeholder="请输入内容" name="invent" class="layui-textarea"></textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <label for="">修治</label>
            <div class="layui-input-inline">
                <textarea placeholder="请输入内容" name="repair" class="layui-textarea"></textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <label for="">图片</label>
            <div class="layui-input-inline">
                <div class="layui-upload-drag" id="img-upload">
                    <i class="layui-icon layui-icon-upload upload-hide"></i>
                    <p class="upload-hide">点击上传，或将文件拖拽到此处</p>
                    <img id="upload-demo">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button id="submit" class="layui-btn layui-btn-radius" lay-submit>提交</button>
                <button type="reset" class="layui-btn layui-btn-radius" onclick="edit()">取消</button>
            </div>
        </div>
    </form>
</div>

<%
    if(editedRs.next()){
        if (editedRs.getString("释名") != null || editedRs.getString("图片") != null || editedRs.getString("气味") != null || editedRs.getString("主治") != null ||
                editedRs.getString("附方") != null || editedRs.getString("集解") != null || editedRs.getString("辨疑") != null || editedRs.getString("发明") != null
         || editedRs.getString("修治") != null)
        {

%>

    <div class="detail-box edited-detail layui-container" id="edited-detial">
        <div class="layui-row">
            <h1>修订版本</h1>
            <div class="layui-col-sm5 layui-col-12">
                <div class="herbal-img">
                    <img src="<%=editedRs.getString("图片") == null ? "./images/herbal/default.jpg" : editedRs.getString("图片")%>" alt="">
                </div>
            </div>
            <div class="layui-col-sm7 layui layui-col-12 herbal-text">
                <%
                        if (editedRs.getString("释名") != null)
                            out.print("<p><span class=\"field\">释名：</span>" + editedRs.getString("释名") + "</p>");
                        if (editedRs.getString("气味") != null)
                            out.print("<p><span class=\"field\">气味：</span>" + editedRs.getString("气味") + "</p>");
                        if (editedRs.getString("主治") != null)
                            out.print("<p><span class=\"field\">主治：</span>" + editedRs.getString("主治") + "</p>");
                        if (editedRs.getString("附方") != null)
                            out.print("<p><span class=\"field\">附方：</span>" + editedRs.getString("附方") + "</p>");
                        if (editedRs.getString("集解") != null)
                            out.print("<p><span class=\"field\">集解：</span>" + editedRs.getString("集解") + "</p>");
                        if (editedRs.getString("辨疑") != null)
                            out.print("<p><span class=\"field\">辨疑：</span>" + editedRs.getString("辨疑") + "</p>");
                        if (editedRs.getString("发明") != null)
                            out.print("<p><span class=\"field\">发明：</span>" + editedRs.getString("发明") + "</p>");
                        if (editedRs.getString("修治") != null)
                            out.print("<p><span class=\"field\">修治：</span>" + editedRs.getString("修治") + "</p>");
                    
                %>
              </div>
    </div>
    <a class="alter" href="javascript: del();">
        <i class="layui-icon layui-icon-delete"></i>
    </a>
</div>
<%
                }
                    }
    } catch (Exception e) {
        throw e;
    }
    finally {
        try {
            if (psmt != null) psmt.close();
            if (conn != null) conn.close();
        } catch (Exception e) {
            throw e;
        }
    }
%>
      


<script src="./js/jquery-3.4.1.min.js"></script>
    <script>
        layui.use(['element', 'form', 'upload'], function() {
            var element = layui.element,
                form = layui.form,
                upload = layui.upload;
            var uploadInst = upload.render({
                elem: '#img-upload' //绑定元素
                ,url: '/herbal/upload' //上传接口
                ,before: function(obj) {
                    document.getElementById("submit").classList.add("layui-btn-disabled");
                    var childs = document.getElementsByClassName("upload-hide");
                    for (var i = childs.length - 1; i >= 0; i--) {
                        childs[i].setAttribute('style', "display: none");
                    }
                    //预读本地文件示例，不支持ie8
                    obj.preview(function(index, file, result) {
                        $('#upload-demo').attr('src', result); //图片链接（base64）
                    });
                }
                ,done: function(res){
                    //上传完毕回调
                    console.log(res.src);
                    document.getElementById("image-src").setAttribute("value",res.src);
                    document.getElementById("submit").classList.remove("layui-btn-disabled");
                }
                ,error: function(){
                    //请求异常回调
                }
            });
        });
        function edit() {
            $("#edit-box").slideToggle("slow");
        }
        function del() {
            layui.use('layer', function(){
                var layer = layui.layer;
                layer.config({
                    skin: 'layui-layer-herbal'
                });
                layer.confirm('真的想要删除？', {btn: ['真的','点错了']},
                function(){
                    layer.closeAll();
                    $.get({url:"./update.jsp?id=<%=id%>&del=true",async:false});
                    $("#edited-detial").slideUp("slow");
                },
                function(){

                });
            });
        }
    </script>

</body>
</html>
