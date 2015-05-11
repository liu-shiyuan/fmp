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
  | Last-Modified: 2015-04-27 10:56:51
  +----------------------------------------------------------------------+
*/
$GLOBALS['httpStatus'] = __HTTPSTATUS_BAD_REQUEST; //默认返回400 
date_default_timezone_set('PRC');
header("Content-type: application/json; charset=utf-8");
if ($GLOBALS['selector'] == __SELECTOR_SINGLE) {
    switch($GLOBALS['operation']) {
    case(__OPERATION_READ):
        if ($_SERVER['REQUEST_METHOD'] == 'POST') {
            $ret=null;
            $ret['status']="true";
            print_r($_SESSION);
            print_r($_POST['commit_data']);
            foreach($_POST['commit_data'] as $publishInfo){
            }
            $GLOBALS['httpStatus']=__HTTPSTATUS_OK;
            echo json_encode($ret);
        }
        break;
    }
}
?>
