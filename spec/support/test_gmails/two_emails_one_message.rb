module TestGmails
	def self.two_emails_one_message
{"tim@126bps.com"=>
  [{"id"=>"14804ad5ff61cc88",
    "threadId"=>"148002f2fd0cf062",
    "labelIds"=>["INBOX", "CATEGORY_PERSONAL", "UNREAD"],
    "snippet"=>
     "This is done. All chocolate has been given. 2014-08-23 17:01 GMT-04:00 Tim Harrison &lt;tharrison@",
    "historyId"=>"12594",
    "payload"=>
     {"mimeType"=>"multipart/alternative",
      "filename"=>"",
      "headers"=>
       [{"name"=>"Delivered-To", "value"=>"tim@126bps.com"},
        {"name"=>"Received",
         "value"=>
          "by 10.202.172.212 with SMTP id v203csp447390oie;        Sat, 23 Aug 2014 14:02:24 -0700 (PDT)"},
        {"name"=>"X-Received",
         "value"=>
          "by 10.182.29.101 with SMTP id j5mr12592174obh.20.1408827744010;        Sat, 23 Aug 2014 14:02:24 -0700 (PDT)"},
        {"name"=>"Return-Path", "value"=>"<tharrison@lxdinc.com>"},
        {"name"=>"Received",
         "value"=>
          "from mail-ob0-f181.google.com (mail-ob0-f181.google.com [209.85.214.181])        by mx.google.com with ESMTPS id p10si41033808obx.13.2014.08.23.14.02.23        for <tim@126bps.com>        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);        Sat, 23 Aug 2014 14:02:23 -0700 (PDT)"},
        {"name"=>"Received-SPF",
         "value"=>
          "none (google.com: tharrison@lxdinc.com does not designate permitted sender hosts) client-ip=209.85.214.181;"},
        {"name"=>"Authentication-Results",
         "value"=>
          "mx.google.com;       spf=neutral (google.com: tharrison@lxdinc.com does not designate permitted sender hosts) smtp.mail=tharrison@lxdinc.com"},
        {"name"=>"Received",
         "value"=>
          "by mail-ob0-f181.google.com with SMTP id va2so9581232obc.40        for <tim@126bps.com>; Sat, 23 Aug 2014 14:02:23 -0700 (PDT)"},
        {"name"=>"X-Google-DKIM-Signature",
         "value"=>
          "v=1; a=rsa-sha256; c=relaxed/relaxed;        d=1e100.net; s=20130820;        h=x-gm-message-state:mime-version:in-reply-to:references:from:date         :message-id:subject:to:cc:content-type;        bh=1gL7muh+2kA0Gul/9hZcfdzxpx9btl1Lwfl6sNL6l2U=;        b=NoYaAqdIJCz3fr41wXFJLrXMGez5IU7/JeUslnCvlrZaBqS/YlxhfZzIx78W1vx07i         DU9KRVP0eVPruYNh2oWhes9buqx4vOvWjh7ROvvfJQ2aZjR5nwr2rzBhl9miAcePabks         hafnXco88qCZ6b02kvVYWbb/YQz+lMjVRYLY92hb3kt0MDfV2Nl20nQ5Zv0MnjPTVoKZ         BLR8DooK8zHyGzONUWTYPbc/M/J3rnil7sOB3JhHHLMz44dz57KPsDzClftCOOL3oYvH         nSUggNcjc20TsJBChk2PEgrz7anStbQab4oMc0Pg61AtydoR3EdOlfXoZk7Bck6bPKNi         lMpg=="},
        {"name"=>"X-Gm-Message-State",
         "value"=>
          "ALoCoQkUaf8M7xGXA1NHl/+R73SYjj3fvT+cU8zk8vZT9c+6G1/PibSA6leFfMMpWEd4gIybmUOB"},
        {"name"=>"X-Received",
         "value"=>
          "by 10.182.236.225 with SMTP id ux1mr12053326obc.57.1408827743873; Sat, 23 Aug 2014 14:02:23 -0700 (PDT)"},
        {"name"=>"MIME-Version", "value"=>"1.0"},
        {"name"=>"Received",
         "value"=>
          "by 10.202.168.88 with HTTP; Sat, 23 Aug 2014 14:02:02 -0700 (PDT)"},
        {"name"=>"In-Reply-To",
         "value"=>
          "<CAODAaKqZp+XhukG2RY4q=2qhqnfUbmTNPVcv_tC1p5iSmzkF6w@mail.gmail.com>"},
        {"name"=>"References",
         "value"=>
          "<CAMcgnnSML=udycdgbycR4uyRbz7H3j4Tj6B3UGS51cDFzEAuUA@mail.gmail.com> <CACBuLZqT964M6ihG=CvMpsXgLy4=OXTsyjKoXCGq0+MVDjx+Ug@mail.gmail.com> <CAMcgnnQ5u0k6XiznORQG70NiE24KeudWzFq=PaHvEqUve8ZjWg@mail.gmail.com> <CAODAaKqZp+XhukG2RY4q=2qhqnfUbmTNPVcv_tC1p5iSmzkF6w@mail.gmail.com>"},
        {"name"=>"From", "value"=>"Tim Harrison <tharrison@lxdinc.com>"},
        {"name"=>"Date", "value"=>"Sat, 23 Aug 2014 17:02:02 -0400"},
        {"name"=>"Message-ID",
         "value"=>
          "<CAODAaKo3U8S+mP7+7zyZ6c16fibQdEg1eZowLx6-gVHmvtnYvA@mail.gmail.com>"},
        {"name"=>"Subject", "value"=>"Re: chocolate procurement"},
        {"name"=>"To", "value"=>"Tim Harrison <tim@126bps.com>"},
        {"name"=>"Cc",
         "value"=>
          "Lindsay Harrison <lindsay@126bps.com>, tim.harrison@yahoo.com"},
        {"name"=>"Content-Type",
         "value"=>
          "multipart/alternative; boundary=001a11c2fad03946b5050152451c"}],
      "body"=>{"size"=>0},
      "parts"=>
       [{"partId"=>"0",
         "mimeType"=>"text/plain",
         "filename"=>"",
         "headers"=>
          [{"name"=>"Content-Type", "value"=>"text/plain; charset=UTF-8"}],
         "body"=>
          {"size"=>1419,
           "data"=>
            "VGhpcyBpcyBkb25lLiAgQWxsIGNob2NvbGF0ZSBoYXMgYmVlbiBnaXZlbi4NCg0KDQoyMDE0LTA4LTIzIDE3OjAxIEdNVC0wNDowMCBUaW0gSGFycmlzb24gPHRoYXJyaXNvbkBseGRpbmMuY29tPjoNCg0KPiBJJ20gZWF0aW5nIHRoZSBjaG9jb2xhdGUuICBJJ20gbm90IHN1cmUgSSBjYW4gZ2l2ZSB5b3UgYW55Lg0KPg0KPg0KPiAyMDE0LTA4LTIzIDE3OjAwIEdNVC0wNDowMCBUaW0gSGFycmlzb24gPHRpbUAxMjZicHMuY29tPjoNCj4NCj4gVGhhbmtzIGZvciB0aGUgdXBkYXRlIQ0KPj4NCj4-IExvcmVtIGlwc3VtIGRvbG9yIHNpdCBhbWV0LCBjb25zZWN0ZXR1ciBhZGlwaXNjaW5nIGVsaXQuIENyYXMgbm9uIG9yY2kNCj4-IHZpdGFlIG1ldHVzIHBvcnR0aXRvciBmaW5pYnVzIGluIHNlZCBlcmF0LiBFdGlhbSB2YXJpdXMgdGVtcHVzIHB1cnVzLCBhdA0KPj4gdmVoaWN1bGEgdG9ydG9yIGNvbmd1ZSBuZWMuIER1aXMgaW4gbW9sbGlzIHRlbGx1cywgbmVjIGRhcGlidXMgZmVsaXMuDQo-PiBNYXVyaXMgaW4gYWNjdW1zYW4gdHVycGlzLCB1dCBwb3J0dGl0b3IgZXJhdC4gQ3JhcyBwcmV0aXVtIGJpYmVuZHVtIHZlbGl0LA0KPj4gbm9uIGVnZXN0YXMgbGVvIGltcGVyZGlldCB2ZWwuDQo-Pg0KPj4NCj4-IDIwMTQtMDgtMjIgMjA6MDggR01ULTA0OjAwIExpbmRzYXkgSGFycmlzb24gPGxpbmRzYXlAMTI2YnBzLmNvbT46DQo-Pg0KPj4gU29tZXRoaW5nIHRoYXQgaXMgbm90IGEgY29tcGxldGlvbi4NCj4-Pg0KPj4-DQo-Pj4gMjAxNC0wOC0yMiAyMDowNiBHTVQtMDQ6MDAgVGltIEhhcnJpc29uIDx0aW1AMTI2YnBzLmNvbT46DQo-Pj4NCj4-PiBUaW0sIHdvdWxkIHlvdSBwbGVhc2Ugc2VuZCBtZSB5b3VyIGNob2NvbGF0ZT8gIExvcmVtIGlwc3VtIGRvbG9yIHNpdA0KPj4-PiBhbWV0LCBjb25zZWN0ZXR1ciBhZGlwaXNjaW5nIGVsaXQuDQo-Pj4-DQo-Pj4-IFZlc3RpYnVsdW0gc2VkIGZhY2lsaXNpcyBsaWJlcm8uIFBlbGxlbnRlc3F1ZSB1bGxhbWNvcnBlciBkYXBpYnVzDQo-Pj4-IHRvcnRvciwgaWQgbGFjaW5pYSBsb3JlbSBjb25zZWN0ZXR1ciB2aXRhZS4gSW4gbW9sZXN0aWUgbnVsbGEgb2RpbywgaWQNCj4-Pj4gdGluY2lkdW50IHNhcGllbiBhZGlwaXNjaW5nIGVnZXQuIEN1cmFiaXR1ciBpbiBlZ2VzdGFzIG5pc2wuIEludGVyZHVtIGV0DQo-Pj4-IG1hbGVzdWFkYSBmYW1lcyBhYyBhbnRlIGlwc3VtIHByaW1pcyBpbiBmYXVjaWJ1cy4NCj4-Pj4NCj4-Pj4gU2VkIGVsZWlmZW5kIHRpbmNpZHVudCB0b3J0b3IsIHNpdCBhbWV0IHRlbXBvciBvcmNpIHBvcnR0aXRvciBhdC4NCj4-Pj4gTWFlY2VuYXMgbGVvIGF1Z3VlLCB0aW5jaWR1bnQgYXQgYWxpcXVldCBldCwgdm9sdXRwYXQgdml0YWUgaXBzdW0uDQo-Pj4-DQo-Pj4-IFRoYW5rcyENCj4-Pj4NCj4-Pg0KPj4-DQo-Pg0KPg0K"}},
        {"partId"=>"1",
         "mimeType"=>"text/html",
         "filename"=>"",
         "headers"=>
          [{"name"=>"Content-Type", "value"=>"text/html; charset=UTF-8"},
           {"name"=>"Content-Transfer-Encoding", "value"=>"quoted-printable"}],
         "body"=>
          {"size"=>3070,
           "data"=>
            "PGRpdiBkaXI9Imx0ciI-VGhpcyBpcyBkb25lLiDCoEFsbCBjaG9jb2xhdGUgaGFzIGJlZW4gZ2l2ZW4uPC9kaXY-PGRpdiBjbGFzcz0iZ21haWxfZXh0cmEiPjxicj48YnI-PGRpdiBjbGFzcz0iZ21haWxfcXVvdGUiPjIwMTQtMDgtMjMgMTc6MDEgR01ULTA0OjAwIFRpbSBIYXJyaXNvbiA8c3BhbiBkaXI9Imx0ciI-Jmx0OzxhIGhyZWY9Im1haWx0bzp0aGFycmlzb25AbHhkaW5jLmNvbSIgdGFyZ2V0PSJfYmxhbmsiPnRoYXJyaXNvbkBseGRpbmMuY29tPC9hPiZndDs8L3NwYW4-Ojxicj4NCg0KPGJsb2NrcXVvdGUgY2xhc3M9ImdtYWlsX3F1b3RlIiBzdHlsZT0ibWFyZ2luOjAgMCAwIC44ZXg7Ym9yZGVyLWxlZnQ6MXB4ICNjY2Mgc29saWQ7cGFkZGluZy1sZWZ0OjFleCI-PGRpdiBkaXI9Imx0ciI-SSYjMzk7bSBlYXRpbmcgdGhlIGNob2NvbGF0ZS4gwqBJJiMzOTttIG5vdCBzdXJlIEkgY2FuIGdpdmUgeW91IGFueS48L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9leHRyYSI-PGJyPjxicj4NCg0KPGRpdiBjbGFzcz0iZ21haWxfcXVvdGUiPjIwMTQtMDgtMjMgMTc6MDAgR01ULTA0OjAwIFRpbSBIYXJyaXNvbiA8c3BhbiBkaXI9Imx0ciI-Jmx0OzxhIGhyZWY9Im1haWx0bzp0aW1AMTI2YnBzLmNvbSIgdGFyZ2V0PSJfYmxhbmsiPnRpbUAxMjZicHMuY29tPC9hPiZndDs8L3NwYW4-OjxkaXY-PGRpdiBjbGFzcz0iaDUiPjxicj4NCjxibG9ja3F1b3RlIGNsYXNzPSJnbWFpbF9xdW90ZSIgc3R5bGU9Im1hcmdpbjowIDAgMCAuOGV4O2JvcmRlci1sZWZ0OjFweCAjY2NjIHNvbGlkO3BhZGRpbmctbGVmdDoxZXgiPjxkaXYgZGlyPSJsdHIiPlRoYW5rcyBmb3IgdGhlIHVwZGF0ZSE8YnI-PGJyPkxvcmVtIGlwc3VtIGRvbG9yIHNpdCBhbWV0LCBjb25zZWN0ZXR1ciBhZGlwaXNjaW5nIGVsaXQuIENyYXMgbm9uIG9yY2kgdml0YWUgbWV0dXMgcG9ydHRpdG9yIGZpbmlidXMgaW4gc2VkIGVyYXQuIEV0aWFtIHZhcml1cyB0ZW1wdXMgcHVydXMsIGF0IHZlaGljdWxhIHRvcnRvciBjb25ndWUgbmVjLiBEdWlzIGluIG1vbGxpcyB0ZWxsdXMsIG5lYyBkYXBpYnVzIGZlbGlzLiBNYXVyaXMgaW4gYWNjdW1zYW4gdHVycGlzLCB1dCBwb3J0dGl0b3IgZXJhdC4gQ3JhcyBwcmV0aXVtIGJpYmVuZHVtIHZlbGl0LCBub24gZWdlc3RhcyBsZW8gaW1wZXJkaWV0IHZlbC48L2Rpdj4NCg0KDQoNCjxkaXYgY2xhc3M9ImdtYWlsX2V4dHJhIj48YnI-PGJyPjxkaXYgY2xhc3M9ImdtYWlsX3F1b3RlIj4yMDE0LTA4LTIyIDIwOjA4IEdNVC0wNDowMCBMaW5kc2F5IEhhcnJpc29uIDxzcGFuIGRpcj0ibHRyIj4mbHQ7PGEgaHJlZj0ibWFpbHRvOmxpbmRzYXlAMTI2YnBzLmNvbSIgdGFyZ2V0PSJfYmxhbmsiPmxpbmRzYXlAMTI2YnBzLmNvbTwvYT4mZ3Q7PC9zcGFuPjo8ZGl2PjxkaXY-DQo8YnI-PGJsb2NrcXVvdGUgY2xhc3M9ImdtYWlsX3F1b3RlIiBzdHlsZT0ibWFyZ2luOjAgMCAwIC44ZXg7Ym9yZGVyLWxlZnQ6MXB4ICNjY2Mgc29saWQ7cGFkZGluZy1sZWZ0OjFleCI-DQo8ZGl2IGRpcj0ibHRyIj5Tb21ldGhpbmcgdGhhdCBpcyBub3QgYSBjb21wbGV0aW9uLjwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2V4dHJhIj48YnI-PGJyPjxkaXYgY2xhc3M9ImdtYWlsX3F1b3RlIj4yMDE0LTA4LTIyIDIwOjA2IEdNVC0wNDowMCBUaW0gSGFycmlzb24gPHNwYW4gZGlyPSJsdHIiPiZsdDs8YSBocmVmPSJtYWlsdG86dGltQDEyNmJwcy5jb20iIHRhcmdldD0iX2JsYW5rIj50aW1AMTI2YnBzLmNvbTwvYT4mZ3Q7PC9zcGFuPjo8ZGl2Pg0KDQoNCg0KPGRpdj48YnI-DQo8YmxvY2txdW90ZSBjbGFzcz0iZ21haWxfcXVvdGUiIHN0eWxlPSJtYXJnaW46MCAwIDAgLjhleDtib3JkZXItbGVmdDoxcHggI2NjYyBzb2xpZDtwYWRkaW5nLWxlZnQ6MWV4Ij48ZGl2IGRpcj0ibHRyIj48c3BhbiBzdHlsZT0iZm9udC1mYW1pbHk6YXJpYWwsc2Fucy1zZXJpZjtmb250LXNpemU6MTNweCI-VGltLCB3b3VsZCB5b3UgcGxlYXNlIHNlbmQgbWUgeW91ciBjaG9jb2xhdGU_IMKgTG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQsIGNvbnNlY3RldHVyIGFkaXBpc2NpbmcgZWxpdC7CoDwvc3Bhbj48ZGl2IHN0eWxlPSJmb250LWZhbWlseTphcmlhbCxzYW5zLXNlcmlmO2ZvbnQtc2l6ZToxM3B4Ij4NCg0KDQoNCg0KDQo8YnI-PC9kaXY-PGRpdiBzdHlsZT0iZm9udC1mYW1pbHk6YXJpYWwsc2Fucy1zZXJpZjtmb250LXNpemU6MTNweCI-VmVzdGlidWx1bSBzZWQgZmFjaWxpc2lzIGxpYmVyby4gUGVsbGVudGVzcXVlIHVsbGFtY29ycGVyIGRhcGlidXMgdG9ydG9yLCBpZCBsYWNpbmlhIGxvcmVtIGNvbnNlY3RldHVyIHZpdGFlLiBJbiBtb2xlc3RpZSBudWxsYSBvZGlvLCBpZCB0aW5jaWR1bnQgc2FwaWVuIGFkaXBpc2NpbmcgZWdldC4gQ3VyYWJpdHVyIGluIGVnZXN0YXMgbmlzbC4gSW50ZXJkdW0gZXQgbWFsZXN1YWRhIGZhbWVzIGFjIGFudGUgaXBzdW0gcHJpbWlzIGluIGZhdWNpYnVzLsKgPC9kaXY-DQoNCg0KDQoNCg0KPGRpdiBzdHlsZT0iZm9udC1mYW1pbHk6YXJpYWwsc2Fucy1zZXJpZjtmb250LXNpemU6MTNweCI-PGJyPjwvZGl2PjxkaXYgc3R5bGU9ImZvbnQtZmFtaWx5OmFyaWFsLHNhbnMtc2VyaWY7Zm9udC1zaXplOjEzcHgiPlNlZCBlbGVpZmVuZCB0aW5jaWR1bnQgdG9ydG9yLCBzaXQgYW1ldCB0ZW1wb3Igb3JjaSBwb3J0dGl0b3IgYXQuIE1hZWNlbmFzIGxlbyBhdWd1ZSwgdGluY2lkdW50IGF0IGFsaXF1ZXQgZXQsIHZvbHV0cGF0IHZpdGFlIGlwc3VtLjxicj4NCg0KDQoNCg0KDQo8L2Rpdj48ZGl2IHN0eWxlPSJmb250LWZhbWlseTphcmlhbCxzYW5zLXNlcmlmO2ZvbnQtc2l6ZToxM3B4Ij48YnI-PC9kaXY-PGRpdiBzdHlsZT0iZm9udC1mYW1pbHk6YXJpYWwsc2Fucy1zZXJpZjtmb250LXNpemU6MTNweCI-VGhhbmtzITwvZGl2PjwvZGl2Pg0KPC9ibG9ja3F1b3RlPjwvZGl2PjwvZGl2PjwvZGl2Pjxicj48L2Rpdj4NCjwvYmxvY2txdW90ZT48L2Rpdj48L2Rpdj48L2Rpdj48YnI-PC9kaXY-DQo8L2Jsb2NrcXVvdGU-PC9kaXY-PC9kaXY-PC9kaXY-PGJyPjwvZGl2Pg0KPC9ibG9ja3F1b3RlPjwvZGl2Pjxicj48L2Rpdj4NCg=="}}]},
    "sizeEstimate"=>7723}],
 "lindsay@126bps.com"=>
  [{"id"=>"14804ad611214514",
    "threadId"=>"148002f3349ba7aa",
    "labelIds"=>["INBOX", "CATEGORY_PERSONAL", "UNREAD"],
    "snippet"=>
     "This is done. All chocolate has been given. 2014-08-23 17:01 GMT-04:00 Tim Harrison &lt;tharrison@",
    "historyId"=>"5862",
    "payload"=>
     {"mimeType"=>"multipart/alternative",
      "filename"=>"",
      "headers"=>
       [{"name"=>"Delivered-To", "value"=>"lindsay@126bps.com"},
        {"name"=>"Received",
         "value"=>
          "by 10.194.184.76 with SMTP id es12csp725wjc;        Sat, 23 Aug 2014 14:02:25 -0700 (PDT)"},
        {"name"=>"X-Received",
         "value"=>
          "by 10.60.146.176 with SMTP id td16mr12562407oeb.28.1408827744441;        Sat, 23 Aug 2014 14:02:24 -0700 (PDT)"},
        {"name"=>"Return-Path", "value"=>"<tharrison@lxdinc.com>"},
        {"name"=>"Received",
         "value"=>
          "from mail-oi0-f46.google.com (mail-oi0-f46.google.com [209.85.218.46])        by mx.google.com with ESMTPS id rc4si41013505obc.17.2014.08.23.14.02.23        for <lindsay@126bps.com>        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);        Sat, 23 Aug 2014 14:02:24 -0700 (PDT)"},
        {"name"=>"Received-SPF",
         "value"=>
          "none (google.com: tharrison@lxdinc.com does not designate permitted sender hosts) client-ip=209.85.218.46;"},
        {"name"=>"Authentication-Results",
         "value"=>
          "mx.google.com;       spf=neutral (google.com: tharrison@lxdinc.com does not designate permitted sender hosts) smtp.mail=tharrison@lxdinc.com"},
        {"name"=>"Received",
         "value"=>
          "by mail-oi0-f46.google.com with SMTP id i138so8695876oig.33        for <lindsay@126bps.com>; Sat, 23 Aug 2014 14:02:23 -0700 (PDT)"},
        {"name"=>"X-Google-DKIM-Signature",
         "value"=>
          "v=1; a=rsa-sha256; c=relaxed/relaxed;        d=1e100.net; s=20130820;        h=x-gm-message-state:mime-version:in-reply-to:references:from:date         :message-id:subject:to:cc:content-type;        bh=1gL7muh+2kA0Gul/9hZcfdzxpx9btl1Lwfl6sNL6l2U=;        b=Jywg750KXm60++9h8eX5EZGrW8ZqdHhpn1RDkgBVZQS/xXuNC4NyVbGmOaTa+SYnjU         lBmUCTj4B8EbOOvYdUQ6ghQf/qYi5tmLHvItVh4r607g98SBcy6UsxPV5I5SC2+iS8Hp         QoEnpKs64JBL1BV9otXQ7UG52cGXFnnFt0x7SGRwzH60SBkCnBiiVav7kLQEZ/AaF7sV         7VqUcV4i52AyOZ40xjzH6F+vWF73wq0HiDNNkA2e/yAEqknzZu/69xaf0s2LjY8J8K1F         DBLzBfWq/pIgTu3ZOxAskRFaxWxK9+9QvH3BzexC9oMFaRpup7JcooN4cEvtcmUS9hJC         /iig=="},
        {"name"=>"X-Gm-Message-State",
         "value"=>
          "ALoCoQmA8yDY+cxWtYyqqjbg8frBYs3whL94V9HONZWm//eCMhPa44na8WLqEdYxVHRZXuMiWwlQ"},
        {"name"=>"X-Received",
         "value"=>
          "by 10.182.236.225 with SMTP id ux1mr12053326obc.57.1408827743873; Sat, 23 Aug 2014 14:02:23 -0700 (PDT)"},
        {"name"=>"MIME-Version", "value"=>"1.0"},
        {"name"=>"Received",
         "value"=>
          "by 10.202.168.88 with HTTP; Sat, 23 Aug 2014 14:02:02 -0700 (PDT)"},
        {"name"=>"In-Reply-To",
         "value"=>
          "<CAODAaKqZp+XhukG2RY4q=2qhqnfUbmTNPVcv_tC1p5iSmzkF6w@mail.gmail.com>"},
        {"name"=>"References",
         "value"=>
          "<CAMcgnnSML=udycdgbycR4uyRbz7H3j4Tj6B3UGS51cDFzEAuUA@mail.gmail.com> <CACBuLZqT964M6ihG=CvMpsXgLy4=OXTsyjKoXCGq0+MVDjx+Ug@mail.gmail.com> <CAMcgnnQ5u0k6XiznORQG70NiE24KeudWzFq=PaHvEqUve8ZjWg@mail.gmail.com> <CAODAaKqZp+XhukG2RY4q=2qhqnfUbmTNPVcv_tC1p5iSmzkF6w@mail.gmail.com>"},
        {"name"=>"From", "value"=>"Tim Harrison <tharrison@lxdinc.com>"},
        {"name"=>"Date", "value"=>"Sat, 23 Aug 2014 17:02:02 -0400"},
        {"name"=>"Message-ID",
         "value"=>
          "<CAODAaKo3U8S+mP7+7zyZ6c16fibQdEg1eZowLx6-gVHmvtnYvA@mail.gmail.com>"},
        {"name"=>"Subject", "value"=>"Re: chocolate procurement"},
        {"name"=>"To", "value"=>"Tim Harrison <tim@126bps.com>"},
        {"name"=>"Cc",
         "value"=>
          "Lindsay Harrison <lindsay@126bps.com>, tim.harrison@yahoo.com"},
        {"name"=>"Content-Type",
         "value"=>
          "multipart/alternative; boundary=001a11c2fad03946b5050152451c"}],
      "body"=>{"size"=>0},
      "parts"=>
       [{"partId"=>"0",
         "mimeType"=>"text/plain",
         "filename"=>"",
         "headers"=>
          [{"name"=>"Content-Type", "value"=>"text/plain; charset=UTF-8"}],
         "body"=>
          {"size"=>1419,
           "data"=>
            "VGhpcyBpcyBkb25lLiAgQWxsIGNob2NvbGF0ZSBoYXMgYmVlbiBnaXZlbi4NCg0KDQoyMDE0LTA4LTIzIDE3OjAxIEdNVC0wNDowMCBUaW0gSGFycmlzb24gPHRoYXJyaXNvbkBseGRpbmMuY29tPjoNCg0KPiBJJ20gZWF0aW5nIHRoZSBjaG9jb2xhdGUuICBJJ20gbm90IHN1cmUgSSBjYW4gZ2l2ZSB5b3UgYW55Lg0KPg0KPg0KPiAyMDE0LTA4LTIzIDE3OjAwIEdNVC0wNDowMCBUaW0gSGFycmlzb24gPHRpbUAxMjZicHMuY29tPjoNCj4NCj4gVGhhbmtzIGZvciB0aGUgdXBkYXRlIQ0KPj4NCj4-IExvcmVtIGlwc3VtIGRvbG9yIHNpdCBhbWV0LCBjb25zZWN0ZXR1ciBhZGlwaXNjaW5nIGVsaXQuIENyYXMgbm9uIG9yY2kNCj4-IHZpdGFlIG1ldHVzIHBvcnR0aXRvciBmaW5pYnVzIGluIHNlZCBlcmF0LiBFdGlhbSB2YXJpdXMgdGVtcHVzIHB1cnVzLCBhdA0KPj4gdmVoaWN1bGEgdG9ydG9yIGNvbmd1ZSBuZWMuIER1aXMgaW4gbW9sbGlzIHRlbGx1cywgbmVjIGRhcGlidXMgZmVsaXMuDQo-PiBNYXVyaXMgaW4gYWNjdW1zYW4gdHVycGlzLCB1dCBwb3J0dGl0b3IgZXJhdC4gQ3JhcyBwcmV0aXVtIGJpYmVuZHVtIHZlbGl0LA0KPj4gbm9uIGVnZXN0YXMgbGVvIGltcGVyZGlldCB2ZWwuDQo-Pg0KPj4NCj4-IDIwMTQtMDgtMjIgMjA6MDggR01ULTA0OjAwIExpbmRzYXkgSGFycmlzb24gPGxpbmRzYXlAMTI2YnBzLmNvbT46DQo-Pg0KPj4gU29tZXRoaW5nIHRoYXQgaXMgbm90IGEgY29tcGxldGlvbi4NCj4-Pg0KPj4-DQo-Pj4gMjAxNC0wOC0yMiAyMDowNiBHTVQtMDQ6MDAgVGltIEhhcnJpc29uIDx0aW1AMTI2YnBzLmNvbT46DQo-Pj4NCj4-PiBUaW0sIHdvdWxkIHlvdSBwbGVhc2Ugc2VuZCBtZSB5b3VyIGNob2NvbGF0ZT8gIExvcmVtIGlwc3VtIGRvbG9yIHNpdA0KPj4-PiBhbWV0LCBjb25zZWN0ZXR1ciBhZGlwaXNjaW5nIGVsaXQuDQo-Pj4-DQo-Pj4-IFZlc3RpYnVsdW0gc2VkIGZhY2lsaXNpcyBsaWJlcm8uIFBlbGxlbnRlc3F1ZSB1bGxhbWNvcnBlciBkYXBpYnVzDQo-Pj4-IHRvcnRvciwgaWQgbGFjaW5pYSBsb3JlbSBjb25zZWN0ZXR1ciB2aXRhZS4gSW4gbW9sZXN0aWUgbnVsbGEgb2RpbywgaWQNCj4-Pj4gdGluY2lkdW50IHNhcGllbiBhZGlwaXNjaW5nIGVnZXQuIEN1cmFiaXR1ciBpbiBlZ2VzdGFzIG5pc2wuIEludGVyZHVtIGV0DQo-Pj4-IG1hbGVzdWFkYSBmYW1lcyBhYyBhbnRlIGlwc3VtIHByaW1pcyBpbiBmYXVjaWJ1cy4NCj4-Pj4NCj4-Pj4gU2VkIGVsZWlmZW5kIHRpbmNpZHVudCB0b3J0b3IsIHNpdCBhbWV0IHRlbXBvciBvcmNpIHBvcnR0aXRvciBhdC4NCj4-Pj4gTWFlY2VuYXMgbGVvIGF1Z3VlLCB0aW5jaWR1bnQgYXQgYWxpcXVldCBldCwgdm9sdXRwYXQgdml0YWUgaXBzdW0uDQo-Pj4-DQo-Pj4-IFRoYW5rcyENCj4-Pj4NCj4-Pg0KPj4-DQo-Pg0KPg0K"}},
        {"partId"=>"1",
         "mimeType"=>"text/html",
         "filename"=>"",
         "headers"=>
          [{"name"=>"Content-Type", "value"=>"text/html; charset=UTF-8"},
           {"name"=>"Content-Transfer-Encoding", "value"=>"quoted-printable"}],
         "body"=>
          {"size"=>3070,
           "data"=>
            "PGRpdiBkaXI9Imx0ciI-VGhpcyBpcyBkb25lLiDCoEFsbCBjaG9jb2xhdGUgaGFzIGJlZW4gZ2l2ZW4uPC9kaXY-PGRpdiBjbGFzcz0iZ21haWxfZXh0cmEiPjxicj48YnI-PGRpdiBjbGFzcz0iZ21haWxfcXVvdGUiPjIwMTQtMDgtMjMgMTc6MDEgR01ULTA0OjAwIFRpbSBIYXJyaXNvbiA8c3BhbiBkaXI9Imx0ciI-Jmx0OzxhIGhyZWY9Im1haWx0bzp0aGFycmlzb25AbHhkaW5jLmNvbSIgdGFyZ2V0PSJfYmxhbmsiPnRoYXJyaXNvbkBseGRpbmMuY29tPC9hPiZndDs8L3NwYW4-Ojxicj4NCg0KPGJsb2NrcXVvdGUgY2xhc3M9ImdtYWlsX3F1b3RlIiBzdHlsZT0ibWFyZ2luOjAgMCAwIC44ZXg7Ym9yZGVyLWxlZnQ6MXB4ICNjY2Mgc29saWQ7cGFkZGluZy1sZWZ0OjFleCI-PGRpdiBkaXI9Imx0ciI-SSYjMzk7bSBlYXRpbmcgdGhlIGNob2NvbGF0ZS4gwqBJJiMzOTttIG5vdCBzdXJlIEkgY2FuIGdpdmUgeW91IGFueS48L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9leHRyYSI-PGJyPjxicj4NCg0KPGRpdiBjbGFzcz0iZ21haWxfcXVvdGUiPjIwMTQtMDgtMjMgMTc6MDAgR01ULTA0OjAwIFRpbSBIYXJyaXNvbiA8c3BhbiBkaXI9Imx0ciI-Jmx0OzxhIGhyZWY9Im1haWx0bzp0aW1AMTI2YnBzLmNvbSIgdGFyZ2V0PSJfYmxhbmsiPnRpbUAxMjZicHMuY29tPC9hPiZndDs8L3NwYW4-OjxkaXY-PGRpdiBjbGFzcz0iaDUiPjxicj4NCjxibG9ja3F1b3RlIGNsYXNzPSJnbWFpbF9xdW90ZSIgc3R5bGU9Im1hcmdpbjowIDAgMCAuOGV4O2JvcmRlci1sZWZ0OjFweCAjY2NjIHNvbGlkO3BhZGRpbmctbGVmdDoxZXgiPjxkaXYgZGlyPSJsdHIiPlRoYW5rcyBmb3IgdGhlIHVwZGF0ZSE8YnI-PGJyPkxvcmVtIGlwc3VtIGRvbG9yIHNpdCBhbWV0LCBjb25zZWN0ZXR1ciBhZGlwaXNjaW5nIGVsaXQuIENyYXMgbm9uIG9yY2kgdml0YWUgbWV0dXMgcG9ydHRpdG9yIGZpbmlidXMgaW4gc2VkIGVyYXQuIEV0aWFtIHZhcml1cyB0ZW1wdXMgcHVydXMsIGF0IHZlaGljdWxhIHRvcnRvciBjb25ndWUgbmVjLiBEdWlzIGluIG1vbGxpcyB0ZWxsdXMsIG5lYyBkYXBpYnVzIGZlbGlzLiBNYXVyaXMgaW4gYWNjdW1zYW4gdHVycGlzLCB1dCBwb3J0dGl0b3IgZXJhdC4gQ3JhcyBwcmV0aXVtIGJpYmVuZHVtIHZlbGl0LCBub24gZWdlc3RhcyBsZW8gaW1wZXJkaWV0IHZlbC48L2Rpdj4NCg0KDQoNCjxkaXYgY2xhc3M9ImdtYWlsX2V4dHJhIj48YnI-PGJyPjxkaXYgY2xhc3M9ImdtYWlsX3F1b3RlIj4yMDE0LTA4LTIyIDIwOjA4IEdNVC0wNDowMCBMaW5kc2F5IEhhcnJpc29uIDxzcGFuIGRpcj0ibHRyIj4mbHQ7PGEgaHJlZj0ibWFpbHRvOmxpbmRzYXlAMTI2YnBzLmNvbSIgdGFyZ2V0PSJfYmxhbmsiPmxpbmRzYXlAMTI2YnBzLmNvbTwvYT4mZ3Q7PC9zcGFuPjo8ZGl2PjxkaXY-DQo8YnI-PGJsb2NrcXVvdGUgY2xhc3M9ImdtYWlsX3F1b3RlIiBzdHlsZT0ibWFyZ2luOjAgMCAwIC44ZXg7Ym9yZGVyLWxlZnQ6MXB4ICNjY2Mgc29saWQ7cGFkZGluZy1sZWZ0OjFleCI-DQo8ZGl2IGRpcj0ibHRyIj5Tb21ldGhpbmcgdGhhdCBpcyBub3QgYSBjb21wbGV0aW9uLjwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2V4dHJhIj48YnI-PGJyPjxkaXYgY2xhc3M9ImdtYWlsX3F1b3RlIj4yMDE0LTA4LTIyIDIwOjA2IEdNVC0wNDowMCBUaW0gSGFycmlzb24gPHNwYW4gZGlyPSJsdHIiPiZsdDs8YSBocmVmPSJtYWlsdG86dGltQDEyNmJwcy5jb20iIHRhcmdldD0iX2JsYW5rIj50aW1AMTI2YnBzLmNvbTwvYT4mZ3Q7PC9zcGFuPjo8ZGl2Pg0KDQoNCg0KPGRpdj48YnI-DQo8YmxvY2txdW90ZSBjbGFzcz0iZ21haWxfcXVvdGUiIHN0eWxlPSJtYXJnaW46MCAwIDAgLjhleDtib3JkZXItbGVmdDoxcHggI2NjYyBzb2xpZDtwYWRkaW5nLWxlZnQ6MWV4Ij48ZGl2IGRpcj0ibHRyIj48c3BhbiBzdHlsZT0iZm9udC1mYW1pbHk6YXJpYWwsc2Fucy1zZXJpZjtmb250LXNpemU6MTNweCI-VGltLCB3b3VsZCB5b3UgcGxlYXNlIHNlbmQgbWUgeW91ciBjaG9jb2xhdGU_IMKgTG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQsIGNvbnNlY3RldHVyIGFkaXBpc2NpbmcgZWxpdC7CoDwvc3Bhbj48ZGl2IHN0eWxlPSJmb250LWZhbWlseTphcmlhbCxzYW5zLXNlcmlmO2ZvbnQtc2l6ZToxM3B4Ij4NCg0KDQoNCg0KDQo8YnI-PC9kaXY-PGRpdiBzdHlsZT0iZm9udC1mYW1pbHk6YXJpYWwsc2Fucy1zZXJpZjtmb250LXNpemU6MTNweCI-VmVzdGlidWx1bSBzZWQgZmFjaWxpc2lzIGxpYmVyby4gUGVsbGVudGVzcXVlIHVsbGFtY29ycGVyIGRhcGlidXMgdG9ydG9yLCBpZCBsYWNpbmlhIGxvcmVtIGNvbnNlY3RldHVyIHZpdGFlLiBJbiBtb2xlc3RpZSBudWxsYSBvZGlvLCBpZCB0aW5jaWR1bnQgc2FwaWVuIGFkaXBpc2NpbmcgZWdldC4gQ3VyYWJpdHVyIGluIGVnZXN0YXMgbmlzbC4gSW50ZXJkdW0gZXQgbWFsZXN1YWRhIGZhbWVzIGFjIGFudGUgaXBzdW0gcHJpbWlzIGluIGZhdWNpYnVzLsKgPC9kaXY-DQoNCg0KDQoNCg0KPGRpdiBzdHlsZT0iZm9udC1mYW1pbHk6YXJpYWwsc2Fucy1zZXJpZjtmb250LXNpemU6MTNweCI-PGJyPjwvZGl2PjxkaXYgc3R5bGU9ImZvbnQtZmFtaWx5OmFyaWFsLHNhbnMtc2VyaWY7Zm9udC1zaXplOjEzcHgiPlNlZCBlbGVpZmVuZCB0aW5jaWR1bnQgdG9ydG9yLCBzaXQgYW1ldCB0ZW1wb3Igb3JjaSBwb3J0dGl0b3IgYXQuIE1hZWNlbmFzIGxlbyBhdWd1ZSwgdGluY2lkdW50IGF0IGFsaXF1ZXQgZXQsIHZvbHV0cGF0IHZpdGFlIGlwc3VtLjxicj4NCg0KDQoNCg0KDQo8L2Rpdj48ZGl2IHN0eWxlPSJmb250LWZhbWlseTphcmlhbCxzYW5zLXNlcmlmO2ZvbnQtc2l6ZToxM3B4Ij48YnI-PC9kaXY-PGRpdiBzdHlsZT0iZm9udC1mYW1pbHk6YXJpYWwsc2Fucy1zZXJpZjtmb250LXNpemU6MTNweCI-VGhhbmtzITwvZGl2PjwvZGl2Pg0KPC9ibG9ja3F1b3RlPjwvZGl2PjwvZGl2PjwvZGl2Pjxicj48L2Rpdj4NCjwvYmxvY2txdW90ZT48L2Rpdj48L2Rpdj48L2Rpdj48YnI-PC9kaXY-DQo8L2Jsb2NrcXVvdGU-PC9kaXY-PC9kaXY-PC9kaXY-PGJyPjwvZGl2Pg0KPC9ibG9ja3F1b3RlPjwvZGl2Pjxicj48L2Rpdj4NCg=="}}]},
    "sizeEstimate"=>7729}]}
	end
end