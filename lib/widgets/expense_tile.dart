import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpenseTile extends StatelessWidget {
  final String title;
  final String value;
  final void Function(BuildContext)? onEditPressed;
  final void Function(BuildContext)? onDeletePressed;

  const ExpenseTile({
    super.key,
    required this.title,
    required this.value,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(), 
        children: [
          SlidableAction(
            onPressed: onEditPressed, 
            icon: Icons.edit,
            backgroundColor: Colors.green,
          ),
          SlidableAction(
            onPressed: onDeletePressed, 
            icon: Icons.delete,
            backgroundColor: Colors.red,
          ),
        ]
      ),
      child: ListTile(
        title: Text(title),
        trailing: Text(value)
      ),
    );
  }
}
