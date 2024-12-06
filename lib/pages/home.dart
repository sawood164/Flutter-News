import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_news/Services/data.dart';
import 'package:flutter_news/Services/news.dart';
import 'package:flutter_news/Services/slider_data.dart';
import 'package:flutter_news/model/article_model.dart';
import 'package:flutter_news/model/category_model.dart';
import 'package:flutter_news/model/slider_model.dart';
import 'package:flutter_news/pages/all_news.dart';
import 'package:flutter_news/pages/category_news.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../widgets/blogtile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<CategoryModel>categories=[];
  List<SliderModel>sliders=[];
  List<ArticleModel>articles=[];
  bool _loading=true;


  int activeIndex=0;
  @override
  void initState() {
    categories= getcategories();
    getSlider();
    getNews();
    super.initState();
  }

     getNews () async {
    News newsclass = News();
    await newsclass.getNews();
    articles=newsclass.news;
    setState(() {
      _loading=false;
    });
  }

  getSlider () async {
    Sliders slider = Sliders();
    await slider.getSlider();
    sliders=slider.sliders;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Flutter"),
            Text("News",
              style: TextStyle(color: Colors.blue,
                  fontWeight: FontWeight.bold
              ),
          ),
          ],

        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _loading? Center(child: CircularProgressIndicator()): SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
              margin: EdgeInsets.only(left: 10.0),
              height: 70,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: categories.length, itemBuilder: (context,index){
              return CategoryTile(
                image: categories[index].image,
                categoryName: categories[index].categoryName,
              );
            }),
            ),

           SizedBox(
           height: 30.0,
           ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Breaking News!"
                      , style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0, ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AllNews(news: "Breaking")));
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              CarouselSlider.builder(
                itemCount: 5,
                itemBuilder: (context, index, realIndex){
                String? res= sliders[index].urlToImage;
                String? res1= sliders[index].title;
                return buildImage(res!, index, res1!);
              }, options: CarouselOptions(
                  height: 250,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                onPageChanged: (index, reason){
                    setState(() {
                      activeIndex=index;
                    });
                }
              ),
              ),
              SizedBox(height: 30.0,
              ),
              Center(child: buildIndicator()),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Trending News!",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AllNews(news: "Trending")));
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0),
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(
                height: 10.0, //hdhdhe
              ),


              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: articles.length,
                    itemBuilder: (context, index){
                  return BlogTile(
                    url: articles[index].url!,
                      desc: articles[index].description!,
                      imageUrl: articles[index].urlToImage!,
                      title: articles[index].title!
                  );
                }),
              ),


    ],
    ),
    ),
    )
    );
  }

  Widget buildImage(String image, int index, String name) =>Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Stack(
            children: [
           ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(

                  height: 250,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width, imageUrl: image,
                ),
            ),
              Container(
                height: 250,
                padding: EdgeInsets.only(left: 10.0),
                margin: EdgeInsets.only(top: 170.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),)),
              child: Center(
                  child: Text(
                    name,
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),)),)

          ]),
        );
  Widget buildIndicator()=> AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: 5,
    effect: SlideEffect(dotWidth: 15, dotHeight: 15, activeDotColor: Colors.blue),
  );
}

class CategoryTile extends StatelessWidget {
  final image, categoryName;

  CategoryTile({this.categoryName, this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoryNews(name: categoryName)));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              image,
              width: 120,
              height: 70, fit: BoxFit.cover,
            ),
          ),
          Container(
            width: 120,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.black38,
            ),
      
            child: Center(
                child: Text(categoryName,
                  style: TextStyle(color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                )
            ),
          )
        ],
        ),
      ),
    );
  }
}






