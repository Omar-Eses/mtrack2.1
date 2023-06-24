import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mtrack/provider/home_view_model.dart';
import 'package:mtrack/screens/pages/teams_pages/task_related/task_screen.dart';
import 'package:mtrack/widgets/custom_appbar.dart';
import 'package:mtrack/widgets/custom_navbar.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // Future.microtask(() => context.read<HomeViewModel>().removeList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, 'Home'),
      body: const HomeContent(),
      bottomNavigationBar: const CustomNavBar(currentPageIndex: 0),
      // floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.speed_outlined),
        onPressed: () {},
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent();

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  void initState() {
    Future.microtask(() => context.read<HomeViewModel>().getUserTasks());
    Future.microtask(() => context.read<HomeViewModel>().getUserData());

    super.initState();
    _resetSelectedDate();
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now().add(const Duration(days: 2));
  }

  late DateTime _selectedDate;
  DateTime today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeViewModel>();

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Text(
              'Welcome ${home.userModel?.fName}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tasks Calendar',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 5),
            TableCalendar(
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarFormat: CalendarFormat.week,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              rowHeight: 35,
              selectedDayPredicate: (day) => isSameDay(day, home.today),
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: home.today,
              onDaySelected: home.onDaySelected,
              // onFormatChanged: (format) {
              //   setState(() {
              //     _calendarFormat = format;
              //   });
              // }),
            ),
            Divider(),
            const SizedBox(height: 10),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: home.userTasksList.length,
                itemBuilder: (context, index) {
                  return home.userTasksList[index].startDate ==
                          DateFormat('dd-MM-yyyy').format(home.today)
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskScreen(
                                  task: home.userTasksList[index],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            clipBehavior: Clip.hardEdge,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            color: Theme.of(context).cardColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        home.userTasksList[index].taskName ??
                                            "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.delete_forever))
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        home.userTasksList[index]
                                                .taskDescription ??
                                            '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                      ),
                                      Text(
                                          "Status : ${home.userTasksList[index].status}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ))
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  // Row(
                                  //   children: peopleInTeam
                                  //       .map((person) =>
                                  //           CircleAvatar(child: Text(person.substring(0, 1))))
                                  //       .toList(),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : SizedBox();
                }),
          ],
        ),
      ),
    );
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      print(today);
      print(DateFormat('dd-MM-yyyy').format(today));
    });
  }
}
