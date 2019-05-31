<%--
  Created by IntelliJ IDEA.
  User: zengm
  Date: 2019/5/30
  Time: 11:16
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
    String explain = null, smell =null, functions = null, accessoryParty = null, collectedExplanations = null,
        question = null, invent = null, repair = null, image = null;
    boolean del = false;
    int id = 0;
    request.setCharacterEncoding("utf-8");
    if (request.getParameter("id") != null && request.getParameter("id") != "")
        id = Integer.parseInt(request.getParameter("id"));
    else {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    if (request.getParameter("del") != null && request.getParameter("del") != "")
        del = true;
    if(request.getParameter("explain") != null && request.getParameter("explain") != "")
        explain = request.getParameter("explain");
    if(request.getParameter("smell") != null && request.getParameter("smell") != "")
        smell = request.getParameter("smell");
    if(request.getParameter("functions") != null && request.getParameter("functions") != "")
        functions = request.getParameter("functions");
    if(request.getParameter("accessoryParty") != null && request.getParameter("accessoryParty") != "")
        accessoryParty = request.getParameter("accessoryParty");
    if(request.getParameter("collectedExplanations") != null && request.getParameter("collectedExplanations") != "")
        collectedExplanations = request.getParameter("collectedExplanations");
    if(request.getParameter("question") != null && request.getParameter("question") != "")
        question = request.getParameter("question");
    if(request.getParameter("invent") != null && request.getParameter("invent") != "")
        invent = request.getParameter("invent");
    if(request.getParameter("repair") != null && request.getParameter("repair") != "")
        repair = request.getParameter("repair");
    if(request.getParameter("image") != null && request.getParameter("image") != "")
        image = request.getParameter("image");


    //    打开连接池
    Context initContext = new InitialContext();
    Context envContext  = (Context)initContext.lookup("java:/comp/env");
    DataSource ds = (DataSource)envContext.lookup("jdbc/herbal");
    Connection conn = null, updateConn = null;
    PreparedStatement psmt = null, updatePsmt = null;
    ResultSet rs = null;
    try {
        conn = ds.getConnection();
        if (del)
        {
            psmt = conn.prepareStatement("DELETE FROM herbal_edited WHERE herbal_id = ?");
            psmt.setInt(1, id);
            psmt.execute();
            return;
        }
        psmt = conn.prepareStatement("SELECT * FROM herbal_edited WHERE herbal_id = ?");
        psmt.setInt(1, id);
        rs = psmt.executeQuery();
        updateConn = ds.getConnection();
        if (!rs.next())
        {
            updatePsmt = updateConn.prepareStatement("INSERT INTO herbal_edited (herbal_id, 释名, 气味, 主治, 附方, 集解," +
                    "辨疑, 发明, 修治, 图片) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            updatePsmt.setInt(1, id);
            if (explain != null)
                updatePsmt.setString(2, explain);
            else
                updatePsmt.setNull(2, Types.VARCHAR);
            if (smell != null)
                updatePsmt.setString(3, smell);
            else
                updatePsmt.setNull(3, Types.VARCHAR);
            if (functions != null)
                updatePsmt.setString(4, functions);
            else
                updatePsmt.setNull(4, Types.VARCHAR);
            if (accessoryParty != null)
                updatePsmt.setString(5, accessoryParty);
            else
                updatePsmt.setNull(5, Types.VARCHAR);
            if (collectedExplanations != null)
                updatePsmt.setString(6, collectedExplanations);
            else
                updatePsmt.setNull(6, Types.VARCHAR);
            if (question != null)
                updatePsmt.setString(7, question);
            else
                updatePsmt.setNull(7, Types.VARCHAR);
            if (invent != null)
                updatePsmt.setString(8, invent);
            else
                updatePsmt.setNull(8, Types.VARCHAR);
            if (repair != null)
                updatePsmt.setString(9, repair);
            else
                updatePsmt.setNull(9, Types.VARCHAR);
            if (image != null)
                updatePsmt.setString(10, image);
            else
                updatePsmt.setNull(10, Types.VARCHAR);
        }
        else
        {
            updatePsmt = updateConn.prepareStatement("UPDATE herbal_edited SET 释名 = ?, 气味 = ?, 主治 = ?, 附方 = ?, 集解 = ?,"  +
                    "辨疑 = ?, 发明 = ?, 修治 = ?, 图片 = ? WHERE herbal_id = ?");
            if (explain != null)
                updatePsmt.setString(1, explain);
            else
                updatePsmt.setNull(1, Types.VARCHAR);
            if (smell != null)
                updatePsmt.setString(2, smell);
            else
                updatePsmt.setNull(2, Types.VARCHAR);
            if (functions != null)
                updatePsmt.setString(3, functions);
            else
                updatePsmt.setNull(3, Types.VARCHAR);
            if (accessoryParty != null)
                updatePsmt.setString(4, accessoryParty);
            else
                updatePsmt.setNull(4, Types.VARCHAR);
            if (collectedExplanations != null)
                updatePsmt.setString(5, collectedExplanations);
            else
                updatePsmt.setNull(5, Types.VARCHAR);
            if (question != null)
                updatePsmt.setString(6, question);
            else
                updatePsmt.setNull(6, Types.VARCHAR);
            if (invent != null)
                updatePsmt.setString(7, invent);
            else
                updatePsmt.setNull(7, Types.VARCHAR);
            if (repair != null)
                updatePsmt.setString(8, repair);
            else
                updatePsmt.setNull(8, Types.VARCHAR);
            if (image != null)
                updatePsmt.setString(9, image);
            else
                updatePsmt.setNull(9, Types.VARCHAR);
            updatePsmt.setInt(10, id);
        }
        updatePsmt.execute();
        response.sendRedirect("detail.jsp?id=" + id);
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
<body>

</body>
</html>
