#!/bin/env ruby
# encoding: utf-8
require 'test_helper'
require 'extract_email_reply'
class SearchableTextObserverTest < ActiveSupport::TestCase
	include ExtractEmailReply

	  test "Chinese From" do
  	text = <<-EMAIL
  	Dear James:\n
       To exchange the left half and right half select, please make the
change on the current LCD as shown in the attachment.\n\n
       Best Regards\n
       Allan\n\n\n
Allan Chang\n\n
------------------------------\n
*发件人：* James Roman\n
*发送时间：* 2013-05-07  01:29:33\n
*收件人：* Randy Napier; allan\n
*抄送：* Todd Bolanz; Charles Wang\n
*主题：* RE: NT-G1286412B-FFSESW-NY M5237A\n
Hi Allan,\n\n\n
  	EMAIL
		expected = "Dear James:\n\n       To exchange the left half and right half select, please make the\nchange on the current LCD as shown in the attachment.\n\n\n       Best Regards\n\n       Allan\n\n\n\nAllan Chang\n\n\n------------------------------"
		assert_equal expected, extract_email_reply(text)
	end

  test "From with stars" do
  	text = <<-TEXT
  	Allan, 
blah blah blah
* *\n
*Randy Napier*\n\n\n
*From:* Randy Napier [mailto:rnapier@lxdinc.com]
*Sent:* Tuesday, May 07, 2013 9:42 AM
*To:* 'allan@example.com'; James Roman
*Cc:* Todd Bolanz; Charles Wang; Tim Harrison
*Subject:* RE: RE: NT-G1286412B-FFSESW-NY M5237A\n
garbage
TEXT
		expected = "Allan, \nblah blah blah\n* *\n\n*Randy Napier*"
    assert_equal expected, extract_email_reply(text)
   end

   test "From without stars" do
		# =================================================================
  	text = <<-TEXT
  	Allan, 
blah blah blah
* *\n
*Randy Napier*\n\n\n
From: Randy Napier [mailto:rnapier@lxdinc.com]
*Sent:* Tuesday, May 07, 2013 9:42 AM
*To:* 'allan@example.com'; James Roman
*Cc:* Todd Bolanz; Charles Wang; Tim Harrison
*Subject:* RE: RE: NT-G1286412B-FFSESW-NY M5237A\n
garbage
TEXT
		expected = "Allan, \nblah blah blah\n* *\n\n*Randy Napier*"
    assert_equal expected, extract_email_reply(text)
  end

  test "Tricky From" do
		# =================================================================
  	text = <<-TEXT
  	Allan, 
blah blah blah
* *
From: this will trick you!\n
*Randy Napier*\n\n\n
*From:* Randy Napier [mailto:rnapier@lxdinc.com]
*Sent:* Tuesday, May 07, 2013 9:42 AM
*To:* 'allan@example.com'; James Roman
*Cc:* Todd Bolanz; Charles Wang; Tim Harrison
*Subject:* RE: RE: NT-G1286412B-FFSESW-NY M5237A\n
garbage
TEXT
		expected = "Allan, \nblah blah blah\n* *\nFrom: this will trick you!\n\n*Randy Napier*"
    assert_equal expected, extract_email_reply(text)
  end

  test "On sometime wrote" do
  	text = "Hello.  I guess....\n\n\nOn Fri, Aug 23, 2013 at 10:18 AM, Tim Harrison <tim@ncwinetrading.com>wrote:\n\n> How do you do!?\n>\n"
  	expected = "Hello.  I guess...."
  	assert_equal expected, extract_email_reply(text)
  end

  test "line breaks in wrote" do
  	text = <<-TEXT
  	Charles,\n
Todd & I say this is ok.  Removing C7 should not void our warranty on their
product.  I can explain this to them, but want to coordinate with you so we
both don't respond.\n\n\n\n
On Fri, Aug 23, 2013 at 10:54 AM, Andrasi, Jamie <
Jamie.Andrasi@safenet-inc.com> wrote:\n
> Hi Charles/Todd/Tim, can you answer Michael’s questions. ****
>
> ** **
TEXT
		expected = "Charles,\n\nTodd & I say this is ok.  Removing C7 should not void our warranty on their\nproduct.  I can explain this to them, but want to coordinate with you so we\nboth don't respond."
		assert_equal expected, extract_email_reply(text)
  end
end

