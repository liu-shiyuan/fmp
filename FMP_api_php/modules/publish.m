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
use FacebookAds\Object\AdImage;
use FacebookAds\Object\Fields\AdImageFields;
use FacebookAds\Object\AdCreative;
use FacebookAds\Object\Fields\AdCreativeFields;
use FacebookAds\Object\Fields\ObjectStorySpecFields;
use FacebookAds\Object\Fields\ObjectStory\LinkDataFields;
use FacebookAds\Object\Fields\ObjectStory\AttachmentDataFields;
use FacebookAds\Object\CustomAudience;
use FacebookAds\Object\Fields\CustomAudienceFields;
use FacebookAds\Object\Values\CustomAudienceTypes;
use FacebookAds\Object\AdCampaign;
use FacebookAds\Object\Fields\AdCampaignFields;
use FacebookAds\Object\Values\AdObjectives;
use FacebookAds\Object\TargetingSpecs;
use FacebookAds\Object\Fields\TargetingSpecsFields;
use FacebookAds\Object\AdSet;
use FacebookAds\Object\Fields\AdSetFields;
use FacebookAds\Object\Fields\AdGroupBidInfoFields;
use FacebookAds\Object\Values\BidTypes;
use FacebookAds\Object\AdGroup;
use FacebookAds\Object\Fields\AdGroupFields;

Api::init($app_id, $app_secret, $access_token);
echo $account_id;

//$page_id = "1568648156711755";
$page_id = "1596284443983918";
//$pixel_id = "";

// Upload Images
echo "Uploading Images";

for($i = 1; $i <= 3; $i++) {
  $image[$i] = new AdImage(null, $account_id);
  $image[$i]->{AdImageFields::FILENAME} = "/tmp/africa/africa{$i}.jpg";
  echo ".";
  $image[$i]->create();
}

echo "\n";

// Create Multi Product Ad Creative

$child_attachments = array();

for($i = 1; $i <= 3; $i++) {
  $child_attachments[] = array(
    AttachmentDataFields::NAME => 'product'.$i,
    AttachmentDataFields::DESCRIPTION => '$'.$i.'00',
    AttachmentDataFields::LINK => 'http://photos.vigyaan.com/africa'.$i,
    AttachmentDataFields::IMAGE_HASH => $image[$i]->hash
  );
}

// The ObjectStorySpec helps bring some order to a complex
// API spec that assists with creating page posts inline.

$object_story_spec = array(
  ObjectStorySpecFields::PAGE_ID => $page_id,
  ObjectStorySpecFields::LINK_DATA => array(
    //LinkDataFields::MESSAGE => 'Check out some pictures from Africa',
    LinkDataFields::LINK => 'http://photos.vigyaan.com',
    LinkDataFields::CAPTION => 'http://photos.vigyaan.com',
    LinkDataFields::CHILD_ATTACHMENTS => $child_attachments
));

$creative = new AdCreative(null, $account_id);

$creative->setData(array(
  AdCreativeFields::NAME => 'Africa Creative 1',
  AdCreativeFields::OBJECT_STORY_SPEC => $object_story_spec
));

$creative->create();
$creative_id = $creative->id;
echo 'Creative ID: '.$creative_id ."\n";

// Create Audience
// Learn more about custom audiences here
// https://developers.facebook.com/docs/marketing-api/custom-audience-website

//$audience = new CustomAudience(null, $account_id);
//$audience->setData(array(
  //CustomAudienceFields::NAME => 'f8 demo custom audience',
  //CustomAudienceFields::DESCRIPTION => 'people who visited our website',
  //CustomAudienceFields::SUBTYPE => 'WEBSITE',
  //CustomAudienceFields::RETENTION_DAYS => 30,
  //CustomAudienceFields::PREFILL => true,
  //CustomAudienceFields::RULE => array(
    //'url' => array(
      //'i_contains' => ''
    //)),
  //'pixel_id' => $pixel_id,
//));

//$audience->create();
//$audience_id = $audience->id;
//echo "Audience ID: " . $audience_id."\n";

// Create a campaign
// A campaign can have one or more adsets

$campaign  = new AdCampaign(null, $account_id);
$campaign->setData(array(
  AdCampaignFields::NAME => 'F8 Demo Campaign',
  //AdCampaignFields::OBJECTIVE => AdObjectives::WEBSITE_CONVERSIONS,
  AdCampaignFields::OBJECTIVE => AdObjectives::WEBSITE_CLICKS,
  AdCampaignFields::STATUS => AdCampaign::STATUS_PAUSED
));

$campaign->validate()->create();
$campaign_id = $campaign->id;
echo "Campaign ID: " . $campaign_id . "\n";

// Create targeting

$targeting = new TargetingSpecs();
$targeting->{TargetingSpecsFields::GEO_LOCATIONS}
= array(
    'countries' => explode('|',$_SESSION[__SESSION_CAMP_EDIT]['step3']['location'])
);
//$targeting->{TargetingSpecsFields::CUSTOM_AUDIENCES} = array(
  //'id' => $audience_id);

// Create an ad set
// An adset can have one or more ad units

$adset = new AdSet(null, $account_id);
$adset->setData(array(
  AdSetFields::NAME => 'My First AdSet',
  AdSetFields::CAMPAIGN_GROUP_ID => $campaign_id,
  AdSetFields::CAMPAIGN_STATUS => AdSet::STATUS_ACTIVE,
  AdSetFields::DAILY_BUDGET => '5000',
  AdSetFields::TARGETING => $targeting,
  AdSetFields::BID_TYPE => BidTypes::BID_TYPE_CPM,
  AdSetFields::BID_INFO => array(AdGroupBidInfoFields::IMPRESSIONS => 2),
  //AdSetFields::BID_TYPE => BidTypes::BID_TYPE_ABSOLUTE_OCPM,
  //AdSetFields::BID_INFO => array('ACTIONS' => 3000),
  AdSetFields::PROMOTED_OBJECT => array('page_id' => $page_id),
  //AdSetFields::PROMOTED_OBJECT => array('pixel_id' => $pixel_id),
));

$adset->validate()->create();
$adset_id = $adset->id;
echo 'AdSet ID: '. $adset_id . "\n";

// Create an ad
// Each ad can only have one creative

//$adgroup = new AdGroup(null, $account_id);
//$adgroup->setData(array(
  //AdGroupFields::CREATIVE => array('creative_id' => $creative_id),
  //AdGroupFields::NAME => 'My First AdGroup',
  //AdGroupFields::CAMPAIGN_ID => $adset_id,
  //AdGroupFields::ADGROUP_STATUS => 'ACTIVE'
//));


echo "account_id:{$account_id}";
echo "adset_id:{$adset_id}";
echo "creative_id:{$creative_id}";
$adgroup = new AdGroup(null, $account_id);
$adgroup->{AdGroupFields::ADGROUP_STATUS} = AdGroup::STATUS_PAUSED;
$adgroup->{AdGroupFields::NAME} = 'test adgroup';
$adgroup->{AdGroupFields::CAMPAIGN_ID}=$adset_id;
$adgroup->{AdGroupFields::CREATIVE} = array('creative_id' => $creative_id);




$adgroup->create();
$adgroup_id=$adgroup->id;
echo 'AdGroup ID: ' . $adgroup_id . "\n";
