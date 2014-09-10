module TestGmails
	def self.same_email_to_two_groups
{"tharrison@lxdinc.com"=>
  [{"id"=>"1485270e22422142",
    "threadId"=>"1485270e22422142",
    "labelIds"=>["INBOX", "CATEGORY_PERSONAL", "UNREAD"],
    "snippet"=>"should result in two messages",
    "historyId"=>"10933018",
    "payload"=>
     {"mimeType"=>"multipart/alternative",
      "filename"=>"",
      "headers"=>
       [{"name"=>"Delivered-To", "value"=>"tharrison@lxdinc.com"},
        {"name"=>"Received",
         "value"=>
          "by 10.202.206.80 with SMTP id e77csp47332oig;        Sun, 7 Sep 2014 16:26:43 -0700 (PDT)"},
        {"name"=>"X-Received",
         "value"=>
          "by 10.60.34.98 with SMTP id y2mr29396567oei.9.1410132402958;        Sun, 07 Sep 2014 16:26:42 -0700 (PDT)"},
        {"name"=>"Return-Path", "value"=>"<tim@126bps.com>"},
        {"name"=>"Received",
         "value"=>
          "from mail-oi0-f41.google.com (mail-oi0-f41.google.com [209.85.218.41])        by mx.google.com with ESMTPS id fu4si11923012oeb.46.2014.09.07.16.26.42        for <tharrison@lxdinc.com>        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);        Sun, 07 Sep 2014 16:26:42 -0700 (PDT)"},
        {"name"=>"Received-SPF",
         "value"=>
          "none (google.com: tim@126bps.com does not designate permitted sender hosts) client-ip=209.85.218.41;"},
        {"name"=>"Authentication-Results",
         "value"=>
          "mx.google.com;       spf=neutral (google.com: tim@126bps.com does not designate permitted sender hosts) smtp.mail=tim@126bps.com"},
        {"name"=>"Received",
         "value"=>
          "by mail-oi0-f41.google.com with SMTP id u20so9370673oif.14        for <tharrison@lxdinc.com>; Sun, 07 Sep 2014 16:26:42 -0700 (PDT)"},
        {"name"=>"X-Google-DKIM-Signature",
         "value"=>
          "v=1; a=rsa-sha256; c=relaxed/relaxed;        d=1e100.net; s=20130820;        h=x-gm-message-state:mime-version:date:message-id:subject:from:to         :content-type;        bh=z9gWa4JHhdrJr20MhTmNBCT3aHLjSDo4/GZAzYQv9B8=;        b=VuLVi2DeYApQ2e8oHgJ9Woc5MUv0YgpHKs9glWzcsukfnGOzVixEe9p3eqpWMZ1DOL         oF4t8SQqvM3N1WRomH6e4XWmse0WgaNOBbpig61KwltGnnme12CG5z6JrGQa4jpQnMTy         8Lp0XiCQ6v2JJj4XdaV/nVtShHmN0NvNS76O5FdIcogo43rhIFSPOHg/64WeK1tQzxlr         D5cj+s+sfRwef0ncZZnEM5a6zby8r1HxiLGXxdnxgzj63ePvPFlkVqMAxt8pfypJh6Vc         ah2kmu5SiUs6gfpzjP7tS2DJU2jq0jIStpVEGty3F2bXgh15yayhdhvd+GkR2uHV2YP8         vDpw=="},
        {"name"=>"X-Gm-Message-State",
         "value"=>
          "ALoCoQluZQodvk/Uxd/+BjBHiM0/C880Ee33cc/nb6RmqRSAxckZiSaBwbses0H1ZaEdgA8sn0G2"},
        {"name"=>"MIME-Version", "value"=>"1.0"},
        {"name"=>"X-Received",
         "value"=>
          "by 10.60.37.165 with SMTP id z5mr28879028oej.16.1410132402469; Sun, 07 Sep 2014 16:26:42 -0700 (PDT)"},
        {"name"=>"Received",
         "value"=>
          "by 10.202.173.77 with HTTP; Sun, 7 Sep 2014 16:26:42 -0700 (PDT)"},
        {"name"=>"X-Originating-IP", "value"=>"[71.77.76.178]"},
        {"name"=>"Date", "value"=>"Sun, 7 Sep 2014 19:26:42 -0400"},
        {"name"=>"Message-ID",
         "value"=>
          "<CAMcgnnQWYV9L_2SSG=-TKnyzMtvD37114r0pQvOW+y-DRjvykw@mail.gmail.com>"},
        {"name"=>"Subject", "value"=>"same email to two groups"},
        {"name"=>"From", "value"=>"Tim Harrison <tim@126bps.com>"},
        {"name"=>"To",
         "value"=>
          "Lindsay Harrison <lindsay@126bps.com>, Tim Harrison <tharrison@lxdinc.com>"},
        {"name"=>"Content-Type",
         "value"=>
          "multipart/alternative; boundary=089e013c6576ef954a0502820856"}],
      "body"=>{"size"=>0},
      "parts"=>
       [{"partId"=>"0",
         "mimeType"=>"text/plain",
         "filename"=>"",
         "headers"=>
          [{"name"=>"Content-Type", "value"=>"text/plain; charset=UTF-8"}],
         "body"=>
          {"size"=>31,
           "data"=>"c2hvdWxkIHJlc3VsdCBpbiB0d28gbWVzc2FnZXMNCg=="}},
        {"partId"=>"1",
         "mimeType"=>"text/html",
         "filename"=>"",
         "headers"=>
          [{"name"=>"Content-Type", "value"=>"text/html; charset=UTF-8"}],
         "body"=>
          {"size"=>52,
           "data"=>
            "PGRpdiBkaXI9Imx0ciI-c2hvdWxkIHJlc3VsdCBpbiB0d28gbWVzc2FnZXM8L2Rpdj4NCg=="}}]},
    "sizeEstimate"=>2648}],
 "lindsay@126bps.com"=>
  [{"id"=>"1485270e2c40d022",
    "threadId"=>"1485270e2c40d022",
    "labelIds"=>["INBOX", "CATEGORY_PERSONAL", "UNREAD"],
    "snippet"=>"should result in two messages",
    "historyId"=>"6336",
    "payload"=>
     {"mimeType"=>"multipart/alternative",
      "filename"=>"",
      "headers"=>
       [{"name"=>"Delivered-To", "value"=>"lindsay@126bps.com"},
        {"name"=>"Received",
         "value"=>
          "by 10.194.184.76 with SMTP id es12csp80229wjc;        Sun, 7 Sep 2014 16:26:46 -0700 (PDT)"},
        {"name"=>"X-Received",
         "value"=>
          "by 10.182.220.226 with SMTP id pz2mr54281obc.76.1410132403339;        Sun, 07 Sep 2014 16:26:43 -0700 (PDT)"},
        {"name"=>"Return-Path", "value"=>"<tim@126bps.com>"},
        {"name"=>"Received",
         "value"=>
          "from mail-oi0-f46.google.com (mail-oi0-f46.google.com [209.85.218.46])        by mx.google.com with ESMTPS id ji4si11922297obb.45.2014.09.07.16.26.42        for <lindsay@126bps.com>        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);        Sun, 07 Sep 2014 16:26:43 -0700 (PDT)"},
        {"name"=>"Received-SPF",
         "value"=>
          "none (google.com: tim@126bps.com does not designate permitted sender hosts) client-ip=209.85.218.46;"},
        {"name"=>"Authentication-Results",
         "value"=>
          "mx.google.com;       spf=neutral (google.com: tim@126bps.com does not designate permitted sender hosts) smtp.mail=tim@126bps.com"},
        {"name"=>"Received",
         "value"=>
          "by mail-oi0-f46.google.com with SMTP id g201so1026865oib.33        for <lindsay@126bps.com>; Sun, 07 Sep 2014 16:26:42 -0700 (PDT)"},
        {"name"=>"X-Google-DKIM-Signature",
         "value"=>
          "v=1; a=rsa-sha256; c=relaxed/relaxed;        d=1e100.net; s=20130820;        h=x-gm-message-state:mime-version:date:message-id:subject:from:to         :content-type;        bh=z9gWa4JHhdrJr20MhTmNBCT3aHLjSDo4/GZAzYQv9B8=;        b=EUP7xA7hVyyYiSwGepzhnGDQJoHQ3N0oVknjgB+h/7gkzaWmKpVA1kz539ZWU2QNIY         v0v9F90+IjQv7Fn9p4XVD/dwAugbJwSTHHoVzDVuyy8qwHfaXxEvi4KS8Q08pczpwcjE         RkjUGdxvslzrL+m+NNp/sHOe5RMdug32HE9MfIHhC6Yb77MtfgiMIlRRpn+IfxOpTkFF         a7pngKnyLHAIg8Ma2cPsa8cLbEeXv3xsAzZdzWO3G10UNL5cRVYY7TkIE+HHn2V0J3Nv         MAimDSeXlm6NCloDomOzP/ly4NPkGJwFAPQTka19jolDFm0JkLkshFhNxt/mGt1PbIqY         RDtw=="},
        {"name"=>"X-Gm-Message-State",
         "value"=>
          "ALoCoQmyCzT9c7EbVtnHyilqtFCuimr0PnRA0rYex10AC18qrn4iHgsU5RfdtB4TuLZHJmHRPRIl"},
        {"name"=>"MIME-Version", "value"=>"1.0"},
        {"name"=>"X-Received",
         "value"=>
          "by 10.60.37.165 with SMTP id z5mr28879028oej.16.1410132402469; Sun, 07 Sep 2014 16:26:42 -0700 (PDT)"},
        {"name"=>"Received",
         "value"=>
          "by 10.202.173.77 with HTTP; Sun, 7 Sep 2014 16:26:42 -0700 (PDT)"},
        {"name"=>"X-Originating-IP", "value"=>"[71.77.76.178]"},
        {"name"=>"Date", "value"=>"Sun, 7 Sep 2014 19:26:42 -0400"},
        {"name"=>"Message-ID",
         "value"=>
          "<CAMcgnnQWYV9L_2SSG=-TKnyzMtvD37114r0pQvOW+y-DRjvykw@mail.gmail.com>"},
        {"name"=>"Subject", "value"=>"same email to two groups"},
        {"name"=>"From", "value"=>"Tim Harrison <tim@126bps.com>"},
        {"name"=>"To",
         "value"=>
          "Lindsay Harrison <lindsay@126bps.com>, Tim Harrison <tharrison@lxdinc.com>"},
        {"name"=>"Content-Type",
         "value"=>
          "multipart/alternative; boundary=089e013c6576ef954a0502820856"}],
      "body"=>{"size"=>0},
      "parts"=>
       [{"partId"=>"0",
         "mimeType"=>"text/plain",
         "filename"=>"",
         "headers"=>
          [{"name"=>"Content-Type", "value"=>"text/plain; charset=UTF-8"}],
         "body"=>
          {"size"=>31,
           "data"=>"c2hvdWxkIHJlc3VsdCBpbiB0d28gbWVzc2FnZXMNCg=="}},
        {"partId"=>"1",
         "mimeType"=>"text/html",
         "filename"=>"",
         "headers"=>
          [{"name"=>"Content-Type", "value"=>"text/html; charset=UTF-8"}],
         "body"=>
          {"size"=>52,
           "data"=>
            "PGRpdiBkaXI9Imx0ciI-c2hvdWxkIHJlc3VsdCBpbiB0d28gbWVzc2FnZXM8L2Rpdj4NCg=="}}]},
    "sizeEstimate"=>2646}]}
	end
end