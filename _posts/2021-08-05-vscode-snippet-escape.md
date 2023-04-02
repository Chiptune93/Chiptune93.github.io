---
title: VS Code - code snippet $ escape ( dollar sign )
categories: [IDE]
tags: [vscode, snippet, escape]
---

VS Code snippet 에서 $ 표시가 필요할 때.

from

```
"mySnippet": {
	"prefix" : [
    	"test"
    ],
    "body":[
    	"$('body').html();",
        "\t\n",
        "\t"
    ]
}
```

To

```
"mySnippet": {
	"prefix" : [
    	"test"
    ],
    "body":[
    	"\\$('body').html();",
        "\t\n",
        "\t"
    ]
}
```

> $ 앞에 \\ 를 붙인다.
