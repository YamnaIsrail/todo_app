import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../constants/colors.dart';
import '../widgets/todo_item.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    _foundToDo = todosList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 50,
                          bottom: 20,
                        ),
                        child: Text(
                          'All ToDos',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      for (ToDo todoo in _foundToDo.reversed)
                        ToDoItem(
                          todo: todoo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _deleteToDoItem,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                        hintText: 'Add a new todo item',
                        border: InputBorder.none),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: 20,
                  right: 20,
                ),
                child: ElevatedButton(
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                  onPressed: () {
                    _addToDoItem(_todoController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: tdBlue,
                    minimumSize: Size(60, 60),
                    elevation: 10,
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
  }

  void _addToDoItem(String toDo) {
    setState(() {
      todosList.add(ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        todoText: toDo,
      ));
    });
    _todoController.clear();
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) => item.todoText!
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(
          Icons.menu,
          color: tdBlack,
          size: 30,
        ),
        Container(
          height: 40,
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAFwAAABcCAMAAADUMSJqAAAAY1BMVEUAAAD////o6Oj29vbQ0ND8/PwvLy+7u7uHh4fW1tbKysru7u4jIyPb29tGRkZzc3NYWFhiYmI0NDROTk4QEBCbm5tsbGxnZ2eRkZEICAioqKg+Pj4YGBiioqJ8fHwqKiqysrITT5JkAAADWUlEQVRogbWa6ZKqMBCFA0kIu0HABQR5/6ecoebOyJLudCv3/LTwM5Wlc06jCEjSoYovddQ0UX2JVahp3xKUh8JujMRC0diFB8HlkIud8lYeAJdTtEfPenZevA+eXdzoWVff3HjgyR1mC3FPPoGbB8YW4mHehxscPQulY/DCzxaieA8e1hR4iawqDNcVhS2EhY8rDCdM+I/gaQfhuqTCS3DoIHygsoVoufCQPHBkTSF4SmcLkTLhJw78woRz2AKEuD9WPLhiwVseHNgvADzmwUcWnLWeQpxY8CsPfuXApeXB64wB10y4dd/VwLQg17JLrGn5vwvK3IoxC97x4LxDFPLgQM2Fak7DggMQ6PMbh31jwlllESiKIDwjGotZ1n0+kQua7CwQbwH7FpLfmlWDCBhOcoqzYB+NeEXiKQVOpwcuSdXrgoQXzEJnZz/7DO0UHzxQaGiZdYe2uB8eFJ5Lo8asvzdwhehZqjxxzhcV5Q0sYU3sC6L+BK2AW+kE2U8OPNDKkaEjRWgukBoLQdZWix+Iqhupr0CEfysxUztW1dhOxpOb34DP0lISOy0+uFRmMvg+DsLvRxS8ZwB41o127rL0Hcbu+u9Hcjt2QA1wwWXaL1YPnOFkscZ96hq/Az5tTmXs3NDppiJfJwI83ZeThzV6tZBaG7tvltjdIDZwObqPo7BDqoowy8JCpQNUzrb1YA1H61R+Lq0tz45u2mtuQhjOzHAuKQjOdJ9O3Sc3nOFUMBkXPDmGvbQaf3BOmwLXq4nxC5dkg+VXLTdwZk7BFa/hytOd5OmhlnCauaLrnw37gbP6QhSlCzjBt/F0fsGZ2Y2i7DXyw9nNYloYTUSalnMuGfGKoliv9jlWpdkq5fqEHjoxv/fdL1wfeIz+AvVfVTzukL7C+queZ73/exQteq+Lm6gA3jbxVGVOeJA8P2fXy/t/dft/Xr8eK+e69i3Fh/NeIb6F+voG0mnjdrdeEc+GuHbpbmdENasBtdBjb+UdFtq8NfGVI6g7k8WNfV0/He4cii0Js90au6MjkIl0xxh8ZICMh7ybq0j8CInpSA7Vym/D8hZLvHjIzYYyAhs6zbme8L6FN0Fnph0dtqYfB2c65MGD+b8QxdTGV9vn9ybv7SUeTEH6R8QXNqYmEUGVp0kAAAAASUVORK5CYII='),
          ),
        ),
      ]),
    );
  }
}