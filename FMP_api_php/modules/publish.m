<?php
/*
  +----------------------------------------------------------------------+
  | Name: publish.m
  +----------------------------------------------------------------------+
  | Comment: 发布
  +----------------------------------------------------------------------+
  | Author:Evoup     evoex@126.com                                                     
  +----------------------------------------------------------------------+
  | Create: 2015-05-11 18:40:23
  +----------------------------------------------------------------------+
  | Last-Modified: 2015-05-11 18:41:29
  +----------------------------------------------------------------------+
 */
use FacebookAds\Api;
Api::init($app_id, $app_secret, $access_token);

/**
 * Step 1 Read the AdAccount (optional)
 */
use FacebookAds\Object\AdAccount;
use FacebookAds\Object\Fields\AdAccountFields;


$account = (new AdAccount($account_id))->read(array(
  AdAccountFields::ID,
  AdAccountFields::NAME,
  AdAccountFields::ACCOUNT_STATUS
));

echo "\nUsing this account: ";
echo $account->id."\n";

// Check the account is active
if($account->{AdAccountFields::ACCOUNT_STATUS} !== 1) {
  throw new \Exception(
    'This account is not active');
}

/**
 * Step 2 Create the AdCampaign
 */
use FacebookAds\Object\AdCampaign;
use FacebookAds\Object\Fields\AdCampaignFields;
use FacebookAds\Object\Values\AdObjectives;

$campaign  = new AdCampaign(null, $account->id);
$campaign->setData(array(
  AdCampaignFields::NAME => "1212121212",
  AdCampaignFields::OBJECTIVE => AdObjectives::WEBSITE_CLICKS,
  //AdCampaignFields::OBJECTIVE => AdObjectives::MOBILE_APP_INSTALLS,
  AdCampaignFields::STATUS => AdCampaign::STATUS_PAUSED,
));

$campaign->validate()->create();
echo "Campaign ID:" . $campaign->id . "\n";

/**
 * Step 3 Search Targeting
 */
use FacebookAds\Object\TargetingSearch;
use FacebookAds\Object\Search\TargetingSearchTypes;

$results = TargetingSearch::search(
  $type = TargetingSearchTypes::INTEREST,
  $class = null,
  $query = 'facebook');

// we'll take the top result for now
$target = (count($results)) ? $results->current() : null;
$target=null;

echo "Using target: ".$target->name."\n";

use FacebookAds\Object\TargetingSpecs;
use FacebookAds\Object\Fields\TargetingSpecsFields;

$targeting = new TargetingSpecs();
/*$targeting->{TargetingSpecsFields::GEO_LOCATIONS}
  = array('countries' => array('GB'));*/
$targeting->{TargetingSpecsFields::GEO_LOCATIONS}
  = array('countries' => array('GB'));
//= array(
    //'countries' => $_SESSION['me']['audience']['country']
//);
$targeting->{TargetingSpecsFields::INTERESTS} = array(
  'id' => $target->id,
  'name' => $target->name
);

/**
 * Step 4 Create the AdSet
 */
use FacebookAds\Object\AdSet;
use FacebookAds\Object\Fields\AdSetFields;
use FacebookAds\Object\Fields\AdGroupBidInfoFields;
use FacebookAds\Object\Values\BidTypes;

$adset = new AdSet(null, $account->id);
$adset->setData(array(
  AdSetFields::NAME => 'Test AdSet',
  AdSetFields::CAMPAIGN_GROUP_ID => $campaign->id,
  AdSetFields::CAMPAIGN_STATUS => AdSet::STATUS_ACTIVE,
  AdSetFields::DAILY_BUDGET => '100',
  AdSetFields::TARGETING => $targeting,
  AdSetFields::BID_TYPE => BidTypes::BID_TYPE_CPM,
  AdSetFields::BID_INFO =>
    array(AdGroupBidInfoFields::IMPRESSIONS => 2),
  AdSetFields::START_TIME =>
    (new \DateTime("now"))->format(\DateTime::ISO8601),
    //(new \DateTime($_SESSION['me']['budget_bidding']['start_time']))->format(\DateTime::ISO8601),
  AdSetFields::END_TIME =>
    (new \DateTime("+2 week"))->format(\DateTime::ISO8601)
    //(new \DateTime($_SESSION['me']['budget_bidding']['end_time']))->format(\DateTime::ISO8601)
));

$adset->validate()->create();
echo 'AdSet  ID: '. $adset->id . "\n";

/**
 * Step 5 Create an AdImage
 */
use FacebookAds\Object\AdImage;
use FacebookAds\Object\Fields\AdImageFields;

$image = new AdImage(null, $account->id);
echo $picLocationArr[0];

$image->{AdImageFields::FILENAME}
  //= SDK_DIR.'/test/misc/FB-f-Logo__blue_512.png';
  //= '/usr/local/share/project/fb/php_adsapi_sdk/vendor/facebook/php-ads-sdk/test/misc/FB-f-Logo__blue_512.png';
  //= $picLocationArr[0];
  ='/tmp/FB-f-Logo__blue_512.png';
  //=$picLocationArr[0];


$image->create();
echo 'Image Hash: '.$image->hash . "\n";



/**
 * Step 5 Create an AdCreative
 */
use FacebookAds\Object\AdCreative;
use FacebookAds\Object\Fields\AdCreativeFields;

$creative = new AdCreative(null, $account->id);
$creative->setData(array(
  AdCreativeFields::NAME => 'Sample Creative',
  AdCreativeFields::TITLE => "title",
  AdCreativeFields::BODY => "body",
  AdCreativeFields::IMAGE_HASH => $image->hash,
  AdCreativeFields::OBJECT_URL => "http://www.baidu.com/" 
));

$creative->create();
echo 'Creative ID: '.$creative->id . "\n";

/**
 * Step 7 Create an AdGroup
 */
use FacebookAds\Object\AdGroup;
use FacebookAds\Object\Fields\AdGroupFields;

$adgroup = new AdGroup(null, $account->id);
$adgroup->setData(array(
  AdGroupFields::CREATIVE =>
    array('creative_id' => $creative->id),
  AdGroupFields::NAME => 'My First AdGroup',
  AdGroupFields::CAMPAIGN_ID => $adset->id,
  AdGroupFields::ADGROUP_STATUS => 'ACTIVE'
));

$adgroup->create();
echo 'AdGroup ID:' . $adgroup->id . "\n";



