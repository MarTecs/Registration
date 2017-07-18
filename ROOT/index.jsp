<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<link rel="stylesheet" href="css/bootstrap.min.css">
<link href="css/font-awesome.min.css" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<link rel="shortcut icon" href="img/sun.png" />
<title>假期留校签到系统</title>

</head>
<body>
	<div class="panel panel-primary" style="top:40%">
		<div class="panel-heading">
			<h1 class="panel-title" style="text-align: center; font-size: 33px; ">
				当日登记</h1>
		</div>
		<div class="panel-body" style="height: auto;background-color: white;">
			<form class="form-horizontal" role="form" method="post">
				<div class="form-group">
					<label for="firstname" class="col-sm-2 control-label"
						style="font-size: 16px;">姓名</label>
					<div class="col-sm-10">
						<input type="text" class="form-control" name="username"
							placeholder="请输入姓名" required="" id="uname">
					</div>
				</div>
				<div class="form-group">
					<label for="lastname" class="col-sm-2 control-label"
						style="font-size: 16px;">性别</label>
					<div class="col-sm-10">
						<div>
							<label class="radio-inline"> <input type="radio"
								name="sex" required="" value="male" checked="checked">男
							</label> <label class="radio-inline" style="margin-left: 100px;">
								<input type="radio" name="sex" value="female">女
							</label>
						</div>
					</div>
				</div>
				<div class="form-group"
					style="width:auto; height:34px;">
					<select name="status" class="form-control"
						style="width: 100px;  display: inline-block; margin-left: 20px; margin-top:5px;"
						required="" id="state">
						<option value="school">在校</option>
						<option value="home">回家</option>
						<option value="practice">实习</option>
						<option value="house">租房</option>
					</select>
					<div class=""
						style="width:auto; display: inline-block;margin-left: 10px;">
						<button type="button" class="btn btn-primary login"
							style="width:90px; line-height:20px; margin-top:-3px;">签到</button>
						<button type="reset" class="btn btn-warning"
							style="width:90px; line-height:20px; margin-top:-3px;">重置</button>
					</div>
				</div>
			</form>
		</div>
		<div class="panel-footer">
			<span>Copyright &copy; 2017 &nbsp;</span>
			<a href="">Elliot</a> &nbsp; & &nbsp;
			<a href="http://www.sivan0222.cn" target="_blank"> SiVan</a> <br> <span style="padding-top: 20px;">如有错误，请联系管理员&nbsp;
			<a target="_blank" href="http://wpa.qq.com/msgrd?v=3&uin=1666762170&site=qq&menu=yes">
				<i class="fa fa-1x fa-qq" aria-hidden="true"></i></a></span>
		</div>
	</div>
	<div class="modal fade" id="mySuccessModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-body" style="text-align: center">
					<p style="padding-top:20px;">
						<span class="glyphicon glyphicon-ok"></span>&nbsp;签到成功
					</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->

	<div class="modal fade" id="myFailedModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-body" style="text-align: center">
					<p style="padding-top:20px;">
						<span class="glyphicon glyphicon-remove"></span>&nbsp;签到失败
					</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->

</body>
<script src="http://libs.baidu.com/jquery/1.9.0/jquery.min.js"></script>
<!-- 包括所有bootstrap的js插件或者可以根据需要使用的js插件调用　-->
<script
	src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
<script>

	$(".login").click(function() {
		var uname = $("#uname").val();
		if (uname == "") {
			return;
		}

		var usex = $("input[name='sex']:checked").val();
		var state = $("#state").val();
		if (usex == 'male') {
			usex = "男";
		} else {
			usex = "女";
		}
		if (state == 'school') {
			state = "在校";
		} else if (state == "home") {
			state = "回家";
		} else if (state == "practice") {
			state = "实习";
		} else {
			state = "租房";
		}
		qiandao(uname, usex, state);
	});


	function qiandao(uname, usex, state) {
		var url = '/user.do?method=check&time=' + Math.random();
		$.ajax({
			url : url,
			type : 'POST',
			data : {
				uname : uname,
				usex : usex,
				state : state
			},
			success : function(response, status) {
				if (response == "不存在") {
					$("#myFailedModal").modal("show");
					return;
				}
				if (response == "已签过") {
					$("#myFailedModal").find("p").html("&nbsp;今天已经签过到了，明天再来吧。");
					$("#myFailedModal").modal("show");
					return;
				}
				if (response == "ok") {
					$("#mySuccessModal").modal("show");
					return;
				}
			},
			error : function(msg) {
				alert(msg)
			}
		});
	}
</script>

</html>
