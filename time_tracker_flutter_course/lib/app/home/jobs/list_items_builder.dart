
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder({Key key,@required this.snapshot,@required this.itemBuilder}) : super(key: key);

  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  // handle the diff states of UI
  @override
  Widget build(BuildContext context) {
    if(snapshot.hasData){
      final List<T> items = snapshot.data;
      // normal state
      if(items.isNotEmpty){
        return _buildList(items);
      } else{
        // empty state
        return EmptyContent();
      }
      // error state
    } else if (snapshot.hasError){
      return EmptyContent(
        title: 'Some went wrong',
        message: 'Can\'t load items right now',
      );
    }
    // loading state
    return Center(child: CircularProgressIndicator());
  }

// return ListView
  Widget _buildList(List<T> items){
    // return a listview.builder + a separator argument. It is suitable for lists  with a large number of items
    // builder is called only for items visible on screen. (Better for performacne)
    return ListView.separated(
      // +2 is so that we have separator in the beginning and at the end
      itemCount: items.length + 2,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index) { 
        if(index == 0 || index == items.length + 1){
          return Container();
        }
        return itemBuilder(context, items[index-1]);
      },
    );
  }
}