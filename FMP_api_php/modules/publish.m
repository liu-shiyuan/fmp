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

use FacebookAds\Object\AdAccount;
use FacebookAds\Object\Fields\AdAccountFields;

/**
 * Step 1 Read the AdAccount (optional)
 */
$account = (new AdAccount($account_id))->read(array(
    AdAccountFields::ID,
    AdAccountFields::NAME,
    AdAccountFields::ACCOUNT_STATUS
));

//echo "account:".$account->id;
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
  AdCampaignFields::NAME => $_SESSION[__SESSION_CAMP_EDIT]['step1']['campaignName'],
  AdCampaignFields::OBJECTIVE => AdObjectives::WEBSITE_CLICKS,
  AdCampaignFields::STATUS => AdCampaign::STATUS_PAUSED,
));
$campaign->validate()->create();
echo "Campaign ID:" . $campaign->id . "\n";
echo "--------------------\n";

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

echo "Using target: ".$target->name."\n";

use FacebookAds\Object\TargetingSpecs;
use FacebookAds\Object\Fields\TargetingSpecsFields;

$targeting = new TargetingSpecs();
$targeting->{TargetingSpecsFields::GEO_LOCATIONS}
  //= array('countries' => explode('|', $_SESSION[__SESSION_CAMP_EDIT]['step3']['location']));
  = array('countries' => array('GB'));
$targeting->{TargetingSpecsFields::INTERESTS} = array(
  'id' => $target->id,
  'name' => $target->name
);

echo "=================\n";

/**
 * Step 4 Create the AdSet
 */
use FacebookAds\Object\AdSet;
use FacebookAds\Object\Fields\AdSetFields;
use FacebookAds\Object\Fields\AdGroupBidInfoFields;
use FacebookAds\Object\Values\BidTypes;

$adset = new AdSet(null, $account->id);
$adset->setData(array(
  AdSetFields::NAME => 'My First AdSet',
  AdSetFields::CAMPAIGN_GROUP_ID => $campaign->id,
  AdSetFields::CAMPAIGN_STATUS => AdSet::STATUS_ACTIVE,
  AdSetFields::DAILY_BUDGET => '100',
  AdSetFields::TARGETING => $targeting,
  AdSetFields::BID_TYPE => BidTypes::BID_TYPE_CPM,
  AdSetFields::BID_INFO =>
    array(AdGroupBidInfoFields::IMPRESSIONS => 2),
  AdSetFields::START_TIME =>
    (new \DateTime("+1 week"))->format(\DateTime::ISO8601),
  AdSetFields::END_TIME =>
    (new \DateTime("+2 week"))->format(\DateTime::ISO8601),
));
echo "22222222222222222\n";
$adset->validate();
echo "333333333333333\n";
//$adset->validate()->create();
$adset->create();
echo "444444444444444\n";
echo 'AdSet  ID: '. $adset->id . "\n";

/**
 * Step 5 Create an AdImage
 */
use FacebookAds\Object\AdImage;
use FacebookAds\Object\Fields\AdImageFields;

$image = new AdImage(null, $account->id);
$image->{AdImageFields::FILENAME}
  //= SDK_DIR.'/test/misc/FB-f-Logo__blue_512.png';
//= "/tmp/dde5ba8bb2c36eaa08cf5b9035bbae34.jpg";
= "/usr/local/share/project/fb/php_adsapi_sdk/vendor/facebook/php-ads-sdk/test/misc/FB-f-Logo__blue_512.png";

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
  AdCreativeFields::TITLE => 'Welcome to the Jungle',
  AdCreativeFields::BODY => 'We\'ve got fun \'n\' games',
  AdCreativeFields::IMAGE_HASH => $image->hash,
  AdCreativeFields::OBJECT_URL => 'http://www.example.com/',
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
));

$adgroup->create();
echo 'AdGroup ID:' . $adgroup->id . "\n";


?>
