module TestGmails
	def self.tim_send_chocolate
		{	
			"id"=>"147f013b28dab16c", 
			"threadId"=>"147f013b28dab16c", 
			"labelIds"=>["INBOX", "CATEGORY_PERSONAL"], 
			"snippet"=>"Tim could you please send me your chocolate?", 
			"historyId"=>"12271", 
			"payload"=> {
				"mimeType"=>"multipart/alternative", "filename"=>"", 
				"headers"=>[
					{"name"=>"Delivered-To", "value"=>"tim@126bps.com"}, 
					{"name"=>"Received", "value"=>"by 10.202.197.67 with SMTP id v64csp242721oif;        Tue, 19 Aug 2014 14:02:09 -0700 (PDT)"}, 
					{"name"=>"X-Received", "value"=>"by 10.60.134.136 with SMTP id pk8mr4342557oeb.81.1408482128926;        Tue, 19 Aug 2014 14:02:08 -0700 (PDT)"}, 
					{"name"=>"Return-Path", "value"=>"<tharrison@lxdinc.com>"}, 
					{"name"=>"Received", "value"=>"from mail-oi0-f54.google.com (mail-oi0-f54.google.com [209.85.218.54])        by mx.google.com with ESMTPS id tt10si27556740oeb.95.2014.08.19.14.02.08        for <tim@126bps.com>        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);        Tue, 19 Aug 2014 14:02:08 -0700 (PDT)"}, 
					{"name"=>"Received-SPF", "value"=>"none (google.com: tharrison@lxdinc.com does not designate permitted sender hosts) client-ip=209.85.218.54;"}, 
					{"name"=>"Authentication-Results", "value"=>"mx.google.com;       spf=neutral (google.com: tharrison@lxdinc.com does not designate permitted sender hosts) smtp.mail=tharrison@lxdinc.com"}, 
					{"name"=>"Received", "value"=>"by mail-oi0-f54.google.com with SMTP id i138so5081120oig.27        for <tim@126bps.com>; Tue, 19 Aug 2014 14:02:08 -0700 (PDT)"}, 
					{"name"=>"X-Google-DKIM-Signature", "value"=>"v=1; a=rsa-sha256; c=relaxed/relaxed;        d=1e100.net; s=20130820;        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc         :content-type;        bh=4/YNLA/foPknWTWqGRNYs3hNLIGZ8/8kWL/Arfs3tns=;        b=BzDQVvb2ThjJsk1GGx+HIEkQz2MvhPiq5lqJxgw9lcCJfdO5zLNaeWV5haMlWG7MSh         TvYYXddM4DzZnrouUEwW7cjybQxQykr9LL0qwIJC46M7OtH4jOtrt61vvYz+vZz+OklT         lFJeAhTVX9fqlMCJ5KGwpOaef6o5QDjZc9/NiFXXeyjCbwFUQvcfb4EieVqZt+UYpfeE         XAeaXlh+mdzLyxd2uYt9QoU1x3l2qkO+Ja/I4vUULrkdhwRkdMl2NPbnYBN/O1AVDDlY         RW90EmIOvbaiRl+VWxbTtYSCUB4Bqjq+qv5bSzRMH5JM/fxxxS/2EzpEd3czckrehg66         Gpfg=="}, 
					{"name"=>"X-Gm-Message-State", "value"=>"ALoCoQnnR0GCOPB13ysfeXKa7b3LOnHt7s6LBc6jUUUXGsfnqKatlvXCmIdgWNXaoUDbJbgAci7m"}, 
					{"name"=>"X-Received", "value"=>"by 10.182.137.195 with SMTP id qk3mr44174112obb.5.1408482128665; Tue, 19 Aug 2014 14:02:08 -0700 (PDT)"}, 
					{"name"=>"MIME-Version", "value"=>"1.0"}, 
					{"name"=>"Received", "value"=>"by 10.202.168.88 with HTTP; Tue, 19 Aug 2014 14:01:48 -0700 (PDT)"}, 
					{"name"=>"From", "value"=>"Tim Harrison <tharrison@lxdinc.com>"}, 
					{"name"=>"Date", "value"=>"Tue, 19 Aug 2014 17:01:48 -0400"}, 
					{"name"=>"Message-ID", "value"=>"<CAODAaKo1nSssSHWe5MipAcbNYBAm6-uvtnjdrSRgqeyOCOGtnw@mail.gmail.com>"}, 
					{"name"=>"Subject", "value"=>"popcorn"}, 
					{"name"=>"To", "value"=>"Tim Harrison <tim@126bps.com>, Lindsay Harrison <lindsay@126bps.com>"}, 
					{"name"=>"Cc", "value"=>"Tim Harrison <heedspin@gmail.com>"}, 
					{"name"=>"Content-Type", 
					"value"=>"multipart/alternative; boundary=001a11c361f6f3b882050101cca9"}
				], 
				"body"=>{"size"=>0}, 
				"parts"=>[
					{
						"partId"=>"0", "mimeType"=>"text/plain", "filename"=>"", 
						"headers"=>[{"name"=>"Content-Type", "value"=>"text/plain; charset=UTF-8"}], 
						"body"=>{"size"=>46, "data"=>"VGltIGNvdWxkIHlvdSBwbGVhc2Ugc2VuZCBtZSB5b3VyIGNob2NvbGF0ZT8NCg=="}
					}, 
					{
						"partId"=>"1", "mimeType"=>"text/html", "filename"=>"", 
						"headers"=>[{"name"=>"Content-Type", "value"=>"text/html; charset=UTF-8"}], 
						"body"=>{"size"=>67, "data"=>"PGRpdiBkaXI9Imx0ciI-VGltIGNvdWxkIHlvdSBwbGVhc2Ugc2VuZCBtZSB5b3VyIGNob2NvbGF0ZT88L2Rpdj4NCg=="}
					}
				]
			}, 
			"sizeEstimate"=>2686
		}
	end
end