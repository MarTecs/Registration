package com.servlet;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dao.UserDao;
import com.pojo.Signinall;
import com.pojo.User;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@WebServlet("/user.do")
public class UserServlet extends HttpServlet {
	private UserDao userDao = new UserDao();

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String method = request.getParameter("method");
		if ("check".equals(method)) {
			toCehck(request, response);
		}
		if ("query".equals(method)) {
			toGetAll(request, response);
		}
		if ("nosignin".equals(method)) {
			toGetNoSignin(request, response);
		}
	}

	private void toGetNoSignin(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String time = request.getParameter("time");
		if (time == null || time.equals("")) {
			Date date = new Date();
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			time = df.format(date);
		}
		JSONArray js = new JSONArray();
		List<Signinall> signinList = userDao.getAll(time);
		List<User> userList = userDao.getAllUser();
		if (signinList == null) {
			for (User user : userList) {
				js.add(getJsonObj(user.getUname()));
			}
			response.getWriter().print(js.toString());
			return;
		}
		for (int i = 0; i < userList.size(); i++) {
			for (int j = 0; j < signinList.size(); j++) {
				if (userList.get(i).getUid() == signinList.get(j).getUid()) {
					userList.remove(i);
				}
			}
		}
		for (User user : userList) {
			js.add(getJsonObj(user.getUname()));
		}
		response.getWriter().print(js.toString());
	}

	private void toGetAll(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String time = request.getParameter("time");
		String page = request.getParameter("page");
		int pageNum = 1;
		int size = 12;
		if (page != null && page.equals("") == false) {
			pageNum = Integer.parseInt(page);
		}
		if (time == null || time.equals("")) {
			Date date = new Date();
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			time = df.format(date);
		}
		List<Signinall> list = userDao.getAll(time, pageNum, size);
		if (list == null) {
			response.getWriter().print("none");
			return;
		}
		JSONArray js = new JSONArray();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日 HH:mm:ss");
		for (Signinall signinall : list) {
			signinall.setTime(sdf.format(signinall.getStime()));
			js.add(getJsonObj(signinall.getSid(), signinall.getUid(), signinall.getTime(), signinall.getUname(),
					signinall.getUsex(), signinall.getState(), signinall.getUclass()));
		}
		response.getWriter().print(js.toString());
	}

	// 验证,如果存在就添加
	private void toCehck(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String uname = request.getParameter("uname");
		String usex = request.getParameter("usex");
		String state = request.getParameter("state");
		User user = userDao.checkUser(uname, usex);
		if (user == null) {
			response.getWriter().print("不存在");
			return;
		}
		int uid = user.getUid();
		Date date = new Date();
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		String time = df.format(date);
		boolean hasSignin = userDao.checkSignIn(uid, time);
		if (hasSignin == true) {
			response.getWriter().print("已签过");
			return;
		}
		Timestamp stime = new Timestamp(System.currentTimeMillis());
		int n = userDao.addSignIn(uid, state, stime);
		if (n > 0)
			response.getWriter().print("ok");
	}

	public JSONObject getJsonObj(String uname) {
		JSONObject jsonobj = new JSONObject();
		jsonobj.put("uname", uname);
		return jsonobj;
	}

	public JSONObject getJsonObj(int sid, int uid, String time, String uname, String usex, String state,
			String uclass) {
		JSONObject jsonobj = new JSONObject();
		jsonobj.put("sid", sid);
		jsonobj.put("uid", uid);
		jsonobj.put("time", time);
		jsonobj.put("uname", uname);
		jsonobj.put("usex", usex);
		jsonobj.put("state", state);
		jsonobj.put("uclass", uclass);
		return jsonobj;
	}
}
