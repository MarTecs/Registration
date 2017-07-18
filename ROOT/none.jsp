<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<html>
<head>
<meta charset="utf-8">
<title>未签到统计</title>
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
				</tr>
			</thead>
			<tbody style="min-height: 430px;">
			</tbody>
		</table>
	</div>
</body>
<script>

	var month = $("#month").val("");
	var day = $("#day").val("");
	var date = new Date();
	var y = date.getFullYear();
	var m = date.getMonth() + 1;
	var d = date.getDate();
	$("#title").html(y + "年" + m + "月" + d + "日未签到名单");
	$(function() {
		query();
	})
	function query(time) {
		var url = '/user.do?method=nosignin';
		$.ajax({
			url : url,
			type : 'POST',
			data : {
				time : time,
			},
			success : function(response, status) {
				if (response == "none") {
					$("tbody").html("");
					return;
				}
				var data = $.parseJSON(response);
				var html = "";
				for (var i = 0; i < data.length; i++) {
					html += "<tr><td>" + ((i * 1) + 1) + "</td>" + "<td>"
						+ data[i].uname + "</td></tr>";
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
		$("#title").html("2017年" + month + "月" + day + "日未签到名单");
		if (month < 10) {
			month = "0" + month;
		}
		if (day < 10) {
			day = "0" + day;
		}
		query("2017-" + month + "-" + day);
	})
</script>
</html>
