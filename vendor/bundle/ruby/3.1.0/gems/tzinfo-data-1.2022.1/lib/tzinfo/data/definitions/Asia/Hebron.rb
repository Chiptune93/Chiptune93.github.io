# encoding: UTF-8

# This file contains data derived from the IANA Time Zone Database
# (https://www.iana.org/time-zones).

module TZInfo
  module Data
    module Definitions
      module Asia
        module Hebron
          include TimezoneDefinition
          
          timezone 'Asia/Hebron' do |tz|
            tz.offset :o0, 8423, 0, :LMT
            tz.offset :o1, 7200, 0, :EET
            tz.offset :o2, 7200, 3600, :EEST
            tz.offset :o3, 7200, 0, :IST
            tz.offset :o4, 7200, 3600, :IDT
            
            tz.transition 1900, 9, :o1, -2185410023, 208681349977, 86400
            tz.transition 1940, 6, :o2, -933638400, 4859563, 2
            tz.transition 1940, 10, :o1, -923097600, 4859807, 2
            tz.transition 1940, 11, :o2, -919036800, 4859901, 2
            tz.transition 1942, 11, :o1, -857347200, 4861329, 2
            tz.transition 1943, 4, :o2, -844300800, 4861631, 2
            tz.transition 1943, 11, :o1, -825811200, 4862059, 2
            tz.transition 1944, 4, :o2, -812678400, 4862363, 2
            tz.transition 1944, 11, :o1, -794188800, 4862791, 2
            tz.transition 1945, 4, :o2, -779846400, 4863123, 2
            tz.transition 1945, 11, :o1, -762652800, 4863521, 2
            tz.transition 1946, 4, :o2, -748310400, 4863853, 2
            tz.transition 1946, 11, :o1, -731116800, 4864251, 2
            tz.transition 1957, 5, :o2, -399088800, 29231621, 12
            tz.transition 1957, 9, :o1, -386650800, 19488899, 8
            tz.transition 1958, 4, :o2, -368330400, 29235893, 12
            tz.transition 1958, 9, :o1, -355114800, 19491819, 8
            tz.transition 1959, 4, :o2, -336790800, 58480547, 24
            tz.transition 1959, 9, :o1, -323654400, 4873683, 2
            tz.transition 1960, 4, :o2, -305168400, 58489331, 24
            tz.transition 1960, 9, :o1, -292032000, 4874415, 2
            tz.transition 1961, 4, :o2, -273632400, 58498091, 24
            tz.transition 1961, 9, :o1, -260496000, 4875145, 2
            tz.transition 1962, 4, :o2, -242096400, 58506851, 24
            tz.transition 1962, 9, :o1, -228960000, 4875875, 2
            tz.transition 1963, 4, :o2, -210560400, 58515611, 24
            tz.transition 1963, 9, :o1, -197424000, 4876605, 2
            tz.transition 1964, 4, :o2, -178938000, 58524395, 24
            tz.transition 1964, 9, :o1, -165801600, 4877337, 2
            tz.transition 1965, 4, :o2, -147402000, 58533155, 24
            tz.transition 1965, 9, :o1, -134265600, 4878067, 2
            tz.transition 1966, 4, :o2, -115866000, 58541915, 24
            tz.transition 1966, 10, :o1, -102643200, 4878799, 2
            tz.transition 1967, 4, :o2, -84330000, 58550675, 24
            tz.transition 1967, 6, :o3, -81313200, 19517171, 8
            tz.transition 1974, 7, :o4, 142380000
            tz.transition 1974, 10, :o3, 150843600
            tz.transition 1975, 4, :o4, 167176800
            tz.transition 1975, 8, :o3, 178664400
            tz.transition 1980, 8, :o4, 334101600
            tz.transition 1980, 9, :o3, 337730400
            tz.transition 1984, 5, :o4, 452642400
            tz.transition 1984, 8, :o3, 462319200
            tz.transition 1985, 4, :o4, 482277600
            tz.transition 1985, 8, :o3, 494370000
            tz.transition 1986, 5, :o4, 516751200
            tz.transition 1986, 9, :o3, 526424400
            tz.transition 1987, 4, :o4, 545436000
            tz.transition 1987, 9, :o3, 558478800
            tz.transition 1988, 4, :o4, 576626400
            tz.transition 1988, 9, :o3, 589323600
            tz.transition 1989, 4, :o4, 609890400
            tz.transition 1989, 9, :o3, 620773200
            tz.transition 1990, 3, :o4, 638316000
            tz.transition 1990, 8, :o3, 651618000
            tz.transition 1991, 3, :o4, 669765600
            tz.transition 1991, 8, :o3, 683672400
            tz.transition 1992, 3, :o4, 701820000
            tz.transition 1992, 9, :o3, 715726800
            tz.transition 1993, 4, :o4, 733701600
            tz.transition 1993, 9, :o3, 747176400
            tz.transition 1994, 3, :o4, 765151200
            tz.transition 1994, 8, :o3, 778021200
            tz.transition 1995, 3, :o4, 796600800
            tz.transition 1995, 9, :o3, 810075600
            tz.transition 1995, 12, :o1, 820447200
            tz.transition 1996, 4, :o2, 828655200
            tz.transition 1996, 9, :o1, 843170400
            tz.transition 1997, 4, :o2, 860104800
            tz.transition 1997, 9, :o1, 874620000
            tz.transition 1998, 4, :o2, 891554400
            tz.transition 1998, 9, :o1, 906069600
            tz.transition 1999, 4, :o2, 924213600
            tz.transition 1999, 10, :o1, 939934800
            tz.transition 2000, 4, :o2, 956268000
            tz.transition 2000, 10, :o1, 971989200
            tz.transition 2001, 4, :o2, 987717600
            tz.transition 2001, 10, :o1, 1003438800
            tz.transition 2002, 4, :o2, 1019167200
            tz.transition 2002, 10, :o1, 1034888400
            tz.transition 2003, 4, :o2, 1050616800
            tz.transition 2003, 10, :o1, 1066338000
            tz.transition 2004, 4, :o2, 1082066400
            tz.transition 2004, 9, :o1, 1096581600
            tz.transition 2005, 4, :o2, 1113516000
            tz.transition 2005, 10, :o1, 1128380400
            tz.transition 2006, 3, :o2, 1143842400
            tz.transition 2006, 9, :o1, 1158872400
            tz.transition 2007, 3, :o2, 1175378400
            tz.transition 2007, 9, :o1, 1189638000
            tz.transition 2008, 3, :o2, 1206655200
            tz.transition 2008, 8, :o1, 1220216400
            tz.transition 2009, 3, :o2, 1238104800
            tz.transition 2009, 9, :o1, 1252015200
            tz.transition 2010, 3, :o2, 1269554400
            tz.transition 2010, 8, :o1, 1281474000
            tz.transition 2011, 3, :o2, 1301608860
            tz.transition 2011, 7, :o1, 1312146000
            tz.transition 2011, 8, :o2, 1314655200
            tz.transition 2011, 9, :o1, 1317330000
            tz.transition 2012, 3, :o2, 1333058400
            tz.transition 2012, 9, :o1, 1348178400
            tz.transition 2013, 3, :o2, 1364508000
            tz.transition 2013, 9, :o1, 1380229200
            tz.transition 2014, 3, :o2, 1395957600
            tz.transition 2014, 10, :o1, 1414098000
            tz.transition 2015, 3, :o2, 1427493600
            tz.transition 2015, 10, :o1, 1445551200
            tz.transition 2016, 3, :o2, 1458946800
            tz.transition 2016, 10, :o1, 1477692000
            tz.transition 2017, 3, :o2, 1490396400
            tz.transition 2017, 10, :o1, 1509141600
            tz.transition 2018, 3, :o2, 1521846000
            tz.transition 2018, 10, :o1, 1540591200
            tz.transition 2019, 3, :o2, 1553810400
            tz.transition 2019, 10, :o1, 1572037200
            tz.transition 2020, 3, :o2, 1585346400
            tz.transition 2020, 10, :o1, 1603490400
            tz.transition 2021, 3, :o2, 1616796000
            tz.transition 2021, 10, :o1, 1635458400
            tz.transition 2022, 3, :o2, 1648332000
            tz.transition 2022, 10, :o1, 1666908000
            tz.transition 2023, 3, :o2, 1679781600
            tz.transition 2023, 10, :o1, 1698357600
            tz.transition 2024, 3, :o2, 1711836000
            tz.transition 2024, 10, :o1, 1729807200
            tz.transition 2025, 3, :o2, 1743285600
            tz.transition 2025, 10, :o1, 1761256800
            tz.transition 2026, 3, :o2, 1774735200
            tz.transition 2026, 10, :o1, 1792706400
            tz.transition 2027, 3, :o2, 1806184800
            tz.transition 2027, 10, :o1, 1824760800
            tz.transition 2028, 3, :o2, 1837634400
            tz.transition 2028, 10, :o1, 1856210400
            tz.transition 2029, 3, :o2, 1869084000
            tz.transition 2029, 10, :o1, 1887660000
            tz.transition 2030, 3, :o2, 1901138400
            tz.transition 2030, 10, :o1, 1919109600
            tz.transition 2031, 3, :o2, 1932588000
            tz.transition 2031, 10, :o1, 1950559200
            tz.transition 2032, 3, :o2, 1964037600
            tz.transition 2032, 10, :o1, 1982613600
            tz.transition 2033, 3, :o2, 1995487200
            tz.transition 2033, 10, :o1, 2014063200
            tz.transition 2034, 3, :o2, 2026936800
            tz.transition 2034, 10, :o1, 2045512800
            tz.transition 2035, 3, :o2, 2058386400
            tz.transition 2035, 10, :o1, 2076962400
            tz.transition 2036, 3, :o2, 2090440800
            tz.transition 2036, 10, :o1, 2108412000
            tz.transition 2037, 3, :o2, 2121890400
            tz.transition 2037, 10, :o1, 2139861600
            tz.transition 2038, 3, :o2, 2153340000, 29586125, 12
            tz.transition 2038, 10, :o1, 2171916000, 29588705, 12
            tz.transition 2039, 3, :o2, 2184789600, 29590493, 12
            tz.transition 2039, 10, :o1, 2203365600, 29593073, 12
            tz.transition 2040, 3, :o2, 2216239200, 29594861, 12
            tz.transition 2040, 10, :o1, 2234815200, 29597441, 12
            tz.transition 2041, 3, :o2, 2248293600, 29599313, 12
            tz.transition 2041, 10, :o1, 2266264800, 29601809, 12
            tz.transition 2042, 3, :o2, 2279743200, 29603681, 12
            tz.transition 2042, 10, :o1, 2297714400, 29606177, 12
            tz.transition 2043, 3, :o2, 2311192800, 29608049, 12
            tz.transition 2043, 10, :o1, 2329164000, 29610545, 12
            tz.transition 2044, 3, :o2, 2342642400, 29612417, 12
            tz.transition 2044, 10, :o1, 2361218400, 29614997, 12
            tz.transition 2045, 3, :o2, 2374092000, 29616785, 12
            tz.transition 2045, 10, :o1, 2392668000, 29619365, 12
            tz.transition 2046, 3, :o2, 2405541600, 29621153, 12
            tz.transition 2046, 10, :o1, 2424117600, 29623733, 12
            tz.transition 2047, 3, :o2, 2437596000, 29625605, 12
            tz.transition 2047, 10, :o1, 2455567200, 29628101, 12
            tz.transition 2048, 3, :o2, 2469045600, 29629973, 12
            tz.transition 2048, 10, :o1, 2487016800, 29632469, 12
            tz.transition 2049, 3, :o2, 2500495200, 29634341, 12
            tz.transition 2049, 10, :o1, 2519071200, 29636921, 12
            tz.transition 2050, 3, :o2, 2531944800, 29638709, 12
            tz.transition 2050, 10, :o1, 2550520800, 29641289, 12
            tz.transition 2051, 3, :o2, 2563394400, 29643077, 12
            tz.transition 2051, 10, :o1, 2581970400, 29645657, 12
            tz.transition 2052, 3, :o2, 2595448800, 29647529, 12
            tz.transition 2052, 10, :o1, 2613420000, 29650025, 12
            tz.transition 2053, 3, :o2, 2626898400, 29651897, 12
            tz.transition 2053, 10, :o1, 2644869600, 29654393, 12
            tz.transition 2054, 3, :o2, 2658348000, 29656265, 12
            tz.transition 2054, 10, :o1, 2676319200, 29658761, 12
            tz.transition 2055, 3, :o2, 2689797600, 29660633, 12
            tz.transition 2055, 10, :o1, 2708373600, 29663213, 12
            tz.transition 2056, 3, :o2, 2721247200, 29665001, 12
            tz.transition 2056, 10, :o1, 2739823200, 29667581, 12
            tz.transition 2057, 3, :o2, 2752696800, 29669369, 12
            tz.transition 2057, 10, :o1, 2771272800, 29671949, 12
            tz.transition 2058, 3, :o2, 2784751200, 29673821, 12
            tz.transition 2058, 10, :o1, 2802722400, 29676317, 12
            tz.transition 2059, 3, :o2, 2816200800, 29678189, 12
            tz.transition 2059, 10, :o1, 2834172000, 29680685, 12
            tz.transition 2060, 3, :o2, 2847650400, 29682557, 12
            tz.transition 2060, 10, :o1, 2866226400, 29685137, 12
            tz.transition 2061, 3, :o2, 2879100000, 29686925, 12
            tz.transition 2061, 10, :o1, 2897676000, 29689505, 12
            tz.transition 2062, 3, :o2, 2910549600, 29691293, 12
            tz.transition 2062, 10, :o1, 2929125600, 29693873, 12
            tz.transition 2063, 3, :o2, 2941999200, 29695661, 12
            tz.transition 2063, 10, :o1, 2960575200, 29698241, 12
            tz.transition 2064, 3, :o2, 2974053600, 29700113, 12
            tz.transition 2064, 10, :o1, 2992024800, 29702609, 12
            tz.transition 2065, 3, :o2, 3005503200, 29704481, 12
            tz.transition 2065, 10, :o1, 3023474400, 29706977, 12
            tz.transition 2066, 3, :o2, 3036952800, 29708849, 12
            tz.transition 2066, 10, :o1, 3055528800, 29711429, 12
            tz.transition 2067, 3, :o2, 3068402400, 29713217, 12
            tz.transition 2067, 10, :o1, 3086978400, 29715797, 12
            tz.transition 2068, 3, :o2, 3099852000, 29717585, 12
            tz.transition 2068, 10, :o1, 3118428000, 29720165, 12
            tz.transition 2069, 3, :o2, 3131906400, 29722037, 12
            tz.transition 2069, 10, :o1, 3149877600, 29724533, 12
            tz.transition 2070, 3, :o2, 3163356000, 29726405, 12
            tz.transition 2070, 10, :o1, 3181327200, 29728901, 12
            tz.transition 2071, 3, :o2, 3194805600, 29730773, 12
            tz.transition 2071, 10, :o1, 3212776800, 29733269, 12
            tz.transition 2072, 3, :o2, 3226255200, 29735141, 12
            tz.transition 2072, 10, :o1, 3244831200, 29737721, 12
          end
        end
      end
    end
  end
end
