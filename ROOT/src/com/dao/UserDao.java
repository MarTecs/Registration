package com.dao;

import java.sql.Timestamp;
import java.util.List;

import com.pojo.Signinall;
import com.pojo.User;
import com.util.DButil;

public class UserDao {
	public User checkUser(String uname, String usex) {
		String sql = "select uid,uname,usex from user where uname=? and usex=?  limit 1";
		List<User> result = DButil.query(User.class, sql, uname, usex);
		if (result.size() > 0) {
			return result.get(0);
		}
		return null;
	}

	public List<User> getAllUser() {
		String sql = "select * from user";
		List<User> list = DButil.query(User.class, sql);
		if (list.size() > 0) {
			return list;
		}
		return null;
	}

	public boolean checkSignIn(int uid, String time) {
		String sql = "select * from signinall where uid=? and DATE_FORMAT(stime,'%Y-%m-%d')=? limit 1";
		List<Signinall> result = DButil.query(Signinall.class, sql, uid, time);
		if (result.size() > 0) {
			return true;
		}
		return false;
	}

	public int addSignIn(int uid, String state, Timestamp stime) {
		String sql = "insert into signin(uid,state,stime) values(?,?,?)";
		int n = DButil.zsg(sql, uid, state, stime);
		return n;
	}

	public List<Signinall> getAll(String time, int pageNum, int size) {
		String sql = "select * from signinall where DATE_FORMAT(stime,'%Y-%m-%d')=? limit ?,?";
		List<Signinall> list = DButil.query(Signinall.class, sql, time, (pageNum - 1) * size, size);
		if (list.size() > 0) {
			return list;
		}
		return null;
	}

	public List<Signinall> getAll(String time) {
		String sql = "select * from signinall where DATE_FORMAT(stime,'%Y-%m-%d')=?";
		List<Signinall> list = DButil.query(Signinall.class, sql, time);
		if (list.size() > 0) {
			return list;
		}
		return null;
	}
}
