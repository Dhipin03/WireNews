import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wirenews/controller/home_screen_controller.dart';
import 'package:wirenews/controller/login_screen_controller.dart';
import 'package:wirenews/utils/constants/colorconstants.dart';
import 'package:wirenews/utils/constants/image_constants.dart';
import 'package:wirenews/view/blog_view_screen/blogView_screen.dart';
import 'package:wirenews/view/home_screen/widgets/newscard_widget.dart';
import 'package:wirenews/view/savedarticle_screen/savedarticle_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> categoryList = [
    'All',
    'Business',
    'Sports',
    'Health',
    'Entertainment',
    'Science',
    'Technology'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await context
            .read<HomeScreenController>()
            .getNewsbyCategory(categoryname: 'general');
        context.read<LoginScreenController>().getCurrentUser();
        context.read<HomeScreenController>().resetindex();
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String day = DateFormat('EEEE').format(DateTime.now());
    final String date = DateFormat('dd').format(DateTime.now());
    final String month = DateFormat('MMMM').format(DateTime.now());

    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBarSection(),
      drawer: _buildDrawerSection(),
      body: DefaultTabController(
        length: 6,
        child: Consumer<HomeScreenController>(
          builder: (context, provider, _) => Column(
            children: [
              _buildCategorySelectionWithDateSection(
                  month, date, day, provider),
              const SizedBox(height: 24),
              _buildNewsListSection(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBarSection() {
    return AppBar(
      leading: Consumer<HomeScreenController>(
        builder: (context, provider, _) => provider.issearckclicked
            ? IconButton(
                onPressed: () => provider.clicksearch(),
                icon: const Icon(Icons.cancel, color: Colors.white),
              )
            : IconButton(
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                icon: const Icon(Icons.menu, color: Colors.white),
              ),
      ),
      centerTitle: true,
      backgroundColor: Colorconstants.primarycolor,
      title: Consumer<HomeScreenController>(
        builder: (context, homecontroller, child) =>
            homecontroller.issearckclicked
                ? _buildSearchField()
                : Text(
                    'WireNews',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
      ),
      actions: [
        Consumer<HomeScreenController>(
          builder: (context, homecontroller, child) =>
              homecontroller.issearckclicked
                  ? SizedBox()
                  : IconButton(
                      onPressed: () => homecontroller.clicksearch(),
                      icon: Icon(Icons.search_rounded, color: Colors.white),
                    ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: searchController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        textAlign: TextAlign.left,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                context
                    .read<HomeScreenController>()
                    .searchNews(searchitem: searchController.text);
                searchController.clear();
              }
            },
            icon: Icon(Icons.search, color: Colors.white),
          ),
          fillColor: Colorconstants.greycolor.withOpacity(0.6),
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerSection() {
    return Drawer(
      child: Consumer<LoginScreenController>(
        builder: (context, logincontroller, child) => Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              height: 80,
              decoration: BoxDecoration(
                color: Colorconstants.primarycolor,
              ),
              child: Center(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: logincontroller.currentuserphoto != null
                          ? Image.network(
                              logincontroller.currentuserphoto!,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              ImageConstants.wirenewslogopng,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (logincontroller.currentusername != null)
                            Text(
                              logincontroller.currentusername!,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          Text(
                            logincontroller.currentuseremail ?? '',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SavedarticleScreen(),
                          ));
                    },
                    child: const ListTile(
                      leading: Icon(Icons.save),
                      title: Text(
                        'Saved Article',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    onTap: () async {
                      await logincontroller.signOut(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelectionWithDateSection(
    String month,
    String date,
    String day,
    HomeScreenController provider,
  ) {
    return Consumer<HomeScreenController>(
      builder: (context, homecontroller, child) =>
          homecontroller.issearckclicked
              ? const SizedBox()
              : Column(
                  children: [
                    Text(
                      'Today',
                      style: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '$month $date, $day',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categoryList.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: _buildCategoryButton(provider, index),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildCategoryButton(HomeScreenController provider, int index) {
    return InkWell(
      onTap: () async {
        provider.iselected(index);
        final category =
            index == 0 ? 'general' : categoryList[index].toLowerCase();
        await provider.getNewsbyCategory(categoryname: category);
      },
      child: Container(
        decoration: BoxDecoration(
          color: provider.selectedindex == index
              ? Colorconstants.primarycolor
              : Colorconstants.greycolor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        child: Center(
          child: Text(
            categoryList[index],
            style: GoogleFonts.roboto(
              color: provider.selectedindex == index
                  ? Colors.white
                  : Colorconstants.primarycolor,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewsListSection() {
    return Consumer<HomeScreenController>(
      builder: (context, provider, _) {
        if (provider.isloading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.issearckclicked && provider.articles1.isEmpty) {
          return _buildNoResultsFound();
        }

        final articles =
            provider.issearckclicked ? provider.articles1 : provider.articles;

        return Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: articles.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) => InkWell(
              onTap: () => _navigateToBlogView(context, articles[index]),
              child: NewscardWidget(
                imgurl: articles[index].urlToImage ?? '',
                title: articles[index].title ?? '',
                author: articles[index].author ?? '',
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoResultsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: Colorconstants.greycolor,
          ),
          const SizedBox(height: 16),
          Text(
            'No Results Found',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colorconstants.greycolor,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToBlogView(BuildContext context, dynamic article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlogviewScreen(
          url: article.url ?? '',
          author: article.author ?? '',
          imgurl: article.urlToImage ?? '',
          title: article.title ?? '',
          content: article.content ?? '',
        ),
      ),
    );
  }
}
