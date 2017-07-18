<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<html>
<head>
<meta charset="utf-8">
<title>签到统计</title>
<link rel="icon" href="img/sun.png" />
<link rel="stylesheet" href="css/bootstrap.min.css">
<script src="js/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.min.js"></script>
</head>

<body>
	<div>
		<table class="table table-striped">
			<caption>
				<div style="float: left;margin-top: 5px;color:black " id="title"></div>
				<div>
					<div class="col-sm-1">
						<input type="text" class="form-control" id="month" placeholder="月"
							required="" style="width:90px; line-height:20px; ">
					</div>
					<div class="col-sm-1" style="margin-left: -15px">
						<input type="text" class="form-control" name="username"
							placeholder="日" required="" id="day"
							style="width:90px; line-height:20px;">
					</div>
					<button type="button" class="btn btn-primary login"
						style="width:90px; line-height:20px; ">查询</button>
				</div>
			</caption>
			<thead>
				<tr>
					<th>编号</th>
					<th>姓名</th>
					<th>性别</th>
					<th>班级</th>
					<th>签到时间</th>
					<th>状态</th>
				</tr>
			</thead>
			<tbody style="min-height: 430px;">
			</tbody>
		</table>
		<div>
			<ul class="pagination" style="margin-left: 42%;">
				<li><a href="#">1</a></li>
				<li><a href="#">2</a></li>
				<li><a href="#">3</a></li>
				<li><a href="#">4</a></li>
			</ul>
		</div>
		<br>
	</div>
</body>
<script>

	var month = $("#month").val("");
	var day = $("#day").val("");
	var date = new Date();
	var y = date.getFullYear();
	var m = date.getMonth() + 1;
	var d = date.getDate();
	$("#title").html(y + "年" + m + "月" + d + "日签到名单");
	$(function() {
		query();
	})
	function query(time, page) {
		var url = '/user.do?method=query';
		$.ajax({
			url : url,
			type : 'POST',
			data : {
				time : time,
				page : page
			},
			success : function(response, status) {
				if (response == "none") {
					$("tbody").html("");
					return;
				}
				var data = $.parseJSON(response);
				var html = "";
				if (page == null) {
					page = 1;
				}
				for (var i = 0; i < data.length; i++) {

					html += "<tr><td>" + ((page - 1) * 1 * 12 + 1 + i) + "</td>" + "<td>"
						+ data[i].uname + "</td>" + "<td>" + data[i].usex + "</td>"
						+ "<td>" + data[i].uclass + "</td>" + "<td>" + data[i].time + "</td>"
						+ "<td>" + data[i].state + "</td></tr>";
				}
				$("tbody").html("");
				$("tbody").append(html);
			},
			error : function(msg) {
				alert(1)
			}
		});
	}
	$(".login").click(function() {
		var month = $("#month").val();
		var day = $("#day").val();
		if (month == "" || day == "") {
			return;
		}
		$("#title").html("2017年" + month + "月" + day + "日签到名单");
		if (month < 10) {
			month = "0" + month;
		}
		if (day < 10) {
			day = "0" + day;
		}
		query("2017-" + month + "-" + day);
	})
	$(".pagination li a").click(function() {
		var m = date.getMonth() + 1;
		var d = date.getDate();
		page = $(this).html();
		if (m < 10) {
			m = "0" + m;
		}
		if (d < 10) {
			d = "0" + d;
		}
		var time = y + "-" + m + "-" + d;
		query(time, page);
	})
</script>
</html>
