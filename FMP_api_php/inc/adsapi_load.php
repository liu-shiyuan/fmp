<?php
/*
  +----------------------------------------------------------------------+
  | Name: adsapi_load.php
  +----------------------------------------------------------------------+
  | Comment: 加载adsapi和命名空间
  +----------------------------------------------------------------------+
  | Author:Evoup     evoex@126.com                                                     
  +----------------------------------------------------------------------+
  | Create: 2015-05-11 16:55:06
  +----------------------------------------------------------------------+
  | Last-Modified: 2015-05-11 16:55:13
  +----------------------------------------------------------------------+
*/
include dirname(__FILE__)."/../GPLlib/facebook_ads_api/vendor/autoload.php";
use FacebookAds\Api;
use FacebookAds\Object\AdAccount;
use FacebookAds\Object\Fields\AdAccountFields;
use FacebookAds\Object\AdCampaign;
use FacebookAds\Object\Fields\AdCampaignFields;
use FacebookAds\Object\Values\AdObjectives;
use FacebookAds\Object\TargetingSearch;
use FacebookAds\Object\Search\TargetingSearchTypes;
use FacebookAds\Object\TargetingSpecs;
use FacebookAds\Object\Fields\TargetingSpecsFields;
use FacebookAds\Object\AdSet;
use FacebookAds\Object\Fields\AdSetFields;
use FacebookAds\Object\Fields\AdGroupBidInfoFields;
use FacebookAds\Object\Values\BidTypes;
use FacebookAds\Object\AdImage;
use FacebookAds\Object\Fields\AdImageFields;
use FacebookAds\Object\AdCreative;
use FacebookAds\Object\Fields\AdCreativeFields;
use FacebookAds\Object\AdGroup;
use FacebookAds\Object\Fields\AdGroupFields;


?>
