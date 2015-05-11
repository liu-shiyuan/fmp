<?php
/*
  +----------------------------------------------------------------------+
  | Name:publishFun.m
  +----------------------------------------------------------------------+
  | Comment:发布的函数
  +----------------------------------------------------------------------+
  | Author:Evoup     evoex@126.com                                                     
  +----------------------------------------------------------------------+
  | Create: 2015-04-27 10:56:28
  +----------------------------------------------------------------------+
  | Last-Modified: 2015-05-11 14:07:42
  +----------------------------------------------------------------------+
*/
$GLOBALS['httpStatus'] = __HTTPSTATUS_BAD_REQUEST; //默认返回400 
date_default_timezone_set('PRC');
header("Content-type: application/json; charset=utf-8");
if ($GLOBALS['selector'] == __SELECTOR_SINGLE) {
    switch($GLOBALS['operation']) {
    case(__OPERATION_READ):
        if ($_SERVER['REQUEST_METHOD'] == 'POST') {
            $ret=$access_token=null;
            $ret['status']="true";
            print_r($_SESSION);
            print_r($_POST['commit_data']);
            // 获取access token
            include(dirname(__FILE__).'/../inc/conn.php');
            $query="SELECT access_token FROM t_fb_account WHERE ad_account_id=".$_SESSION[__SESSION_CAMP_EDIT]['step1']['billingAccount']." LIMIT 1;";
            $result=$link->query($query);
            if ( !($row = mysqli_fetch_assoc($result)) ) {
                $msgs['err_msg'][]=array('accessToken' => 'access token wrong');
            } else {
                $access_token=$row['access_token'];
            }
            @mysqli_close($link);
            $account_id='act_'.$_SESSION[__SESSION_CAMP_EDIT]['step1']['billingAccount'];
            $app_id=__FACEBOOK_APPID;
            $app_secret=__FACEBOOK_SECRET;

            foreach($_POST['commit_data'] as $publishInfo){
            }
            $GLOBALS['httpStatus']=__HTTPSTATUS_OK;
            echo json_encode($ret);
        }
        break;
    }
}
?>
