package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.sql.Connection;
import util.DBConnection;

public final class index_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List<String> _jspx_dependants;

  private org.glassfish.jsp.api.ResourceInjector _jspx_resourceInjector;

  public java.util.List<String> getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;

    try {
      response.setContentType("text/html; charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("<!DOCTYPE html>\n");
      out.write("<html>\n");
      out.write("<head>\n");
      out.write("    <title>CRCS Login</title>\n");
      out.write("    <style>\n");
      out.write("        body { font-family: Arial; background: #f4f4f4; }\n");
      out.write("        .login-box {\n");
      out.write("            width: 350px;\n");
      out.write("            margin: 100px auto;\n");
      out.write("            padding: 20px;\n");
      out.write("            background: white;\n");
      out.write("            border-radius: 5px;\n");
      out.write("            box-shadow: 0 0 10px #ccc;\n");
      out.write("        }\n");
      out.write("        input, button {\n");
      out.write("            width: 100%;\n");
      out.write("            padding: 10px;\n");
      out.write("            margin-top: 10px;\n");
      out.write("        }\n");
      out.write("        button {\n");
      out.write("            background: green;\n");
      out.write("            color: white;\n");
      out.write("            border: none;\n");
      out.write("            cursor: pointer;\n");
      out.write("        }\n");
      out.write("        .status {\n");
      out.write("            margin-top: 10px;\n");
      out.write("            font-size: 13px;\n");
      out.write("        }\n");
      out.write("    </style>\n");
      out.write("</head>\n");
      out.write("<body>\n");
      out.write("\n");

    // ---- DATABASE CONNECTION TEST ----
    String dbStatus;

    try {
        Connection con = DBConnection.getConnection();
        if (con != null) {
            dbStatus = "Database connected successfully ✔";
            con.close();
        } else {
            dbStatus = "Database connection failed ✖";
        }
    } catch (Exception e) {
        dbStatus = "Database connection failed ✖";
    }

      out.write("\n");
      out.write("\n");
      out.write("<div class=\"login-box\">\n");
      out.write("    <h2>Community Recycling Collection System</h2>\n");
      out.write("\n");
      out.write("    <form action=\"LoginServlet\" method=\"post\">\n");
      out.write("        <input type=\"email\" name=\"email\" placeholder=\"Email\" required />\n");
      out.write("        <input type=\"password\" name=\"password\" placeholder=\"Password\" required />\n");
      out.write("        <button type=\"submit\">Login</button>\n");
      out.write("    </form>\n");
      out.write("\n");
      out.write("    <!-- Error message from login.jsp -->\n");
      out.write("    <p style=\"color:red;\">\n");
      out.write("        ");
      out.print( request.getAttribute("error") != null
                ? request.getAttribute("error")
                : "" );
      out.write("\n");
      out.write("    </p>\n");
      out.write("\n");
      out.write("    <!-- DB connection status -->\n");
      out.write("    <p class=\"status\" style=\"color:green;\">\n");
      out.write("        ");
      out.print( dbStatus );
      out.write("\n");
      out.write("    </p>\n");
      out.write("</div>\n");
      out.write("\n");
      out.write("</body>\n");
      out.write("</html>\n");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
