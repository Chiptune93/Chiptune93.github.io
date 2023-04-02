---

title: YouTube 검색 데이터 가져오기 - YouTube Data Api 연동
description: >
  YouTube 검색 데이터 가져오기 - YouTube Data Api 연동


categories: [Java]
tags: [Java, YouTube, YouTube API]
---



## YouTube Data API

유튜브 채널 검색에 대한 결과를 리스트로 가져오는 예제 코드입니다.
<br/> 아래 소스에는 [검색어][더보기] 기능이 추가되어 해당 값들도 파라미터로 넘겨 받고 있습니다.

애초에 해당 API에서 검색어가 존재해야 데이터를 가져올 수 있고, 결과에는 pageToken 이 항시 넘어오고 해당 토큰을 날려서 페이징 조회도 가능하기 때문에, 페이징 또한 구현이 가능합니다.

자세한 파라미터 및 안내 사항은 다음 주소를 참고해주세요.

[developers.google.com/youtube/v3/docs/search/list?hl=ko](developers.google.com/youtube/v3/docs/search/list?hl=ko)

## Source Cocde

```java
package src.lib.youtubeSearchApi;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Type;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.List;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.reflect.TypeToken;
import com.google.gson.stream.JsonReader;
import src.lib.myMap.MyCamelMap;
import src.lib.myMap.MyMap;
public class youtubeSearchApi {
	public static MyMap youtubeSearch(MyMap paramMap) {
		// 검색결과 list
		MyMap result = new MyMap();
		MyMap info = new MyMap();
		List<MyCamelMap> resultDataList = new ArrayList<MyCamelMap>();
		List<MyCamelMap> list = new ArrayList<MyCamelMap>();
		// key setting
		String apiKey = "{API 키값}";
		// oauth setting
		String oauthKey = "{Oauth 키값}"; // 미사용
		// request parameter setting
		// 참고 사이트 : https://developers.google.com/youtube/v3/docs/search/list?hl=ko
		// 검색어
		String q = paramMap.getStr("searchValue", "");
		// 다음 페이지 토큰
		String nextPageToken = paramMap.getStr("nextPageToken", "");
		// 검색 유형 타입
		String type = "video"; // 비디오만 검색, 허용 값 : [channel|playlist|video]
		// request
		String apiUrl = "https://www.googleapis.com/youtube/v3/search?key=" + apiKey + "&part=snippet" + "&q=" + q + "&type=" + type;
		if (!nextPageToken.equals("") && !nextPageToken.equals(null)) {
			// 다음 페이지 호출인 경우에만 다음 페이지 토큰 값 포함.
			apiUrl += "&pageToken=" + nextPageToken;
		}
		if (paramMap.getStr("searchValue", "").equals("") || paramMap.getStr("searchValue", "").equals(null)) {
			// searchValue 없으면 동작하지 않음.
		} else {
			try {
				// url += URLEncoder.encode(searchValue, "UTF-8");
				// Connect to the URL using Java's native library
				URL url = new URL(apiUrl);
				URLConnection request = url.openConnection();
				request.connect();
				// Convert to a JSON object to print data
				JsonParser jp = new JsonParser(); // from gson
				JsonReader jr = new JsonReader(new InputStreamReader((InputStream)request.getContent()));
				jr.setLenient(true);
				JsonElement root = jp.parse(jr); // Convert the input stream to a json element
				JsonObject rootobj = root.getAsJsonObject(); // May be an array, may be an object.
				// info parsing
				String getNextPageToken = "noMoreResult";
				// next page token 이 있는 경우 가져오고 없는 경우 없다고 표시.
				if (!rootobj.has("nextPageToken")) {
					getNextPageToken = "noMoreResult";
				} else {
					getNextPageToken = rootobj.get("nextPageToken").getAsString();
				}
				JsonObject pageInfo = rootobj.get("pageInfo").getAsJsonObject(); // May be an array, may be an object.
				String totalResult = pageInfo.get("totalResults").getAsString();
				String resultsPerPage = pageInfo.get("resultsPerPage").getAsString();
				info.put("nextPageToken", getNextPageToken);
				info.put("totalResult", totalResult);
				info.put("resultsPerPage", resultsPerPage);
				// items parsing
				JsonArray dataList = rootobj.get("items").getAsJsonArray();
				// map setting
				// 1. title 2. id 3. description 4. published date 5. thumburl
				Gson gson = new Gson();
				Type listType = new TypeToken<ArrayList<MyCamelMap>>() {}.getType();
				resultDataList = gson.fromJson(dataList.toString(), listType);
				for (int i = 0; i < resultDataList.size(); i++) {
					MyCamelMap data = new MyCamelMap();
					data.put("title", dataList.get(i).getAsJsonObject().get("snippet").getAsJsonObject().get("title").getAsString());
					data.put("videoId", dataList.get(i).getAsJsonObject().get("id").getAsJsonObject().get("videoId").getAsString());
					data.put("des", dataList.get(i).getAsJsonObject().get("snippet").getAsJsonObject().get("description").getAsString());
					data.put("date", dataList.get(i).getAsJsonObject().get("snippet").getAsJsonObject().get("publishedAt").getAsString());
					data.put("thumbUrl", dataList.get(i).getAsJsonObject().get("snippet").getAsJsonObject().get("thumbnails").getAsJsonObject().get("default").getAsJsonObject().get("url").getAsString());
					list.add(data);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			result.put("info", info);
			result.put("list", list);
			result.put("paramMap", paramMap);
		}
		return result;
	}

}

```
