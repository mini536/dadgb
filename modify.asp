<!-- #include file="function.asp" -->
<!-- #include file="code.asp" --><%
myfilename="modify.asp"
username=Request.Cookies("username")
userpass=Request.Cookies("userpass")
id=int(Request("id"))
thisttime=Now()
dim listid, modifytimeout
if Request.Cookies("username")=empty or Request.Cookies("userpass")=empty then
error("您还未登录论坛")
message="<li>您还未登录论坛<li><a href=./ulogin.asp>返回登录口</a>"
succeed(""&message&"<meta http-equiv=refresh content=1;url=./ulogin.asp>")
Response.End
end if
set rs=server.createobject("ADODB.Recordset")
sql="select distinction,userface from [user] where username='"&username&"'"
rs.Open sql,Conn,1,1
distinction=Rs("distinction")
userface=Rs("userface")
rs.close
qqwmcopayout=""
sql="select txttitle,username,upid,content,posttime from list,forum where list.id="&id&" and forum.listid=list.id"
rs.Open sql,Conn,1,1
txttitle=rs("txttitle")
upid=rs("upid")
zzname=rs("username")
content=rs("content")
posttime=rs("posttime")
rs.close
if distinction<3 and zzname<>username then error("您没有编辑该文章的权利")


if action="modify" and Request.ServerVariables("request_method") = "POST" then
icon=Request("icon")
txttitle=HTMLEncode(Trim(Request.Form("txttitle")))
content=ContentEncode(RTrim(Request.Form("content")))
if Len(txttitle)<3 then error("文章标题不能小于 3 字符")
if Len(content)>contentlen then error("内容太长,不能超过"&contentlen&"字节")
if Len(content)<3 then error("<文章内容不能小于 3 字符")
if badwords<>empty then
filtrate=split(badwords,"|")
for i = 0 to ubound(filtrate)
txttitle=ReplaceText(txttitle,""&filtrate(i)&"",string(len(filtrate(i)),"*"))
content=ReplaceText(content,""&filtrate(i)&"",string(len(filtrate(i)),"*"))
next
end if
'''''''''''''''''''''''''''''''''''
sql="select * from [list] where id="&id
rs.Open sql,Conn,1,3
rs("icon")=icon
rs("txttitle")=txttitle
rs.update
rs.close
sql="select * from [forum] where listid="&id
rs.Open sql,Conn,1,3
rs("content")=content
rs.update
rs.close
'''''''''
Set rs=Nothing
''''''''''''''''''''''
htmlfilename=id
if upid=0 or upid=empty then upid=id
content = ubb(content)
modifytimeout=""
if ifmodifytime=1 then modifytimeout="本帖在"&thisttime&"被"&username&"重新编辑"
set fileobject = Server.CreateObject("Scripting.FileSystemObject")
TempletTopPath=Server.MapPath("templet\top.html")
TempletBottomPath=Server.MapPath("templet\bottom.html")
set TOPTEMP=fileobject.openTextFile(TempletTopPath,,True)
set BOTTOMTEMP=fileobject.openTextFile(TempletBottomPath,,True)
topt=TOPTEMP.ReadAll 
bottomt=BOTTOMTEMP.ReadAll

topt=replace(topt,"<#title#>", txttitle)
topt=replace(topt,"<#username#>", username)
topt=replace(topt,"<#userface#>", userface)

bottomt=replace(bottomt,"<#posttime#>", posttime)

set addhtmlfile = fileobject.CreateTextFile(Server.MapPath(".")&"\html\"&upid&"\"&htmlfilename&wmhtmlkzn)
addhtmlfile.writeline topt
addhtmlfile.writeline("<table width='100%'  border='0' cellspacing='0' cellpadding='0'>")
addhtmlfile.writeline("<tr><td height='28' align='right'><a href=../../>返回首页</a> | 阅读：<font color=red><script src=../../count.asp?id="&id&"></script></font> 次 | <a href=../../reply.asp?upid="&upid&">回复主题</a> | <a href=../../modify.asp?id="&id&">作者编辑</a> | <a href=javascript:location.reload()>刷新文章</a> | <a href=javascript:window.close()>关闭本页</a></td></tr>")
addhtmlfile.writeline("<tr><td valign=top style=font-size:14px>"&content&"<br><br><font style=font-size:12px;color:#888>"&modifytimeout&"</font><br><br></td></tr>")
addhtmlfile.writeline("<tr><td id=contentads valign=bottom></td></tr>")
addhtmlfile.writeline("</table>")
addhtmlfile.writeline bottomt

Response.Cookies("posttime")=now'在COOKIE里记录发表时间

message="<li>新主题发表成功<li><a href=./>返回论坛首页</a>"
succeed(""&message&"<meta http-equiv=refresh content=3;url=html/"&upid&"/"&htmlfilename&wmhtmlkzn&">")
Response.End
end if'结束存数及生成HTML网页
Set rs=Nothing'
%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title><%=forumname%> 编辑资料</title>
<link href="images/css.css" rel="stylesheet" type="text/css">
</head>

<body>

<script>
function storeCaret(textEl) {if (textEl.createTextRange) textEl.caretPos = document.selection.createRange().duplicate();}
function HighlightAll(theField) {
var tempval=eval("document."+theField)
tempval.focus()
tempval.select()
therange=tempval.createTextRange()
therange.execCommand("Copy")}
function DoTitle(addTitle) {
var revisedTitle;var currentTitle = document.FORM.intopictitle.value;revisedTitle = addTitle+currentTitle;document.FORM.intopictitle.value=revisedTitle;document.FORM.intopictitle.focus();
return;}
</script>
<form name="FORM" action="<%=myfilename%>" method="post" onsubmit="if(this.name.value==''){alert('请填写用户名');return false}else{if(this.pass.value==''){alert('请填写密码');return false}else{if(this.txttitle.value==''){alert('请填写标题');return false}else{if(this.content.value==''){alert('请输入内容');return false}}}}">
	<input type="hidden" name="action" value="modify">
	<input type="hidden" name="id" value="<%=id%>">
	<table border="0" width="80%" cellspacing="1" cellpadding="3" bgcolor="#C0C0C0" align="center">
		<tr>
			<td bgcolor="#FFFFFF" align="right">文章标题：</td>
			<td bgcolor="#FFFFFF" colspan="2">
			<input maxlength="100" size="60" name="txttitle" value="<%=txttitle%>"></td>
		</tr>
		<%
if Request.Cookies("username")=empty or Request.Cookies("userpass")=empty then
%>
		<tr>
			<td bgcolor="#FFFFFF" align="right">用户登陆：</td>
			<td bgcolor="#FFFFFF" colspan="2">用户名：<input maxlength="24" name="username" value="<%=username%>"> 
			密码：<input type="password" maxlength="20" name="userpass" value="<%=userpass%>">
			<font color="#FF0000">*直接输入用户名和密码即可</font></td>
		</tr>
		<%
end if
%>
		<tr>
			<td bgcolor="#FFFFFF" align="right" valign="top">UBB标签说明：<br>
			<font color="#FF0000">(直接复制<br>
			标签代码发布)</font></td>
			<td bgcolor="#FFFFFF">[b]加粗[/b]<br>
			[i]倾斜[/i]<br>
			[u]下划线[/u]<br>
			[strike]删除线[/strike]<br>
			[align=center]居中[/align]<br>
			[align=left]居左[/align]<br>
			[align=right]居右[/align]<br>
			[fly]左右移动[/fly]<br>
			[move]飞行字[/move]<br>
			[color=颜色代码]字体颜色[/color]</td>
			<td bgcolor="#FFFFFF">[bgcolor=颜色代码]字体背景颜色[/bgcolor]<br>
			[size=1到7]]字号大小[/size]<br>
			[img]插入图片[/img]<br>
			[url=连接网址]连接说明[/url]<br>
			[sound]插入背景音乐[/sound]<br>
			[ra]mp3地址或是电台地址[/ra]<br>
			[flash=宽度,高度]flv或是flash地址[/flash]<br>
			[iframe=宽度,高度]插入网页地址[/iframe]<br>
			[mp=宽度,高度]media视频地址[/mp]<br>
			[RM=宽度,高度]raplay视频地址[/rm]</td>
		</tr>
		<tr>
			<td bgcolor="#FFFFFF" align="right" valign="top">文章内容：</td>
			<td bgcolor="#FFFFFF" colspan="2">
			<textarea name="content" rows="15" cols="75" onselect="storeCaret(this);" onclick="storeCaret(this);" onkeyup="storeCaret(this);"><%=content%></textarea></td>
		</tr>
		<tr>
			<td bgcolor="#FFFFFF" colspan="3" align="center">
			<input type="submit" value="发 表" name="button">
			<input type="reset" name="Submit" value="重 置"></td>
		</tr>
	</table>
</form>

</body>

</html>
