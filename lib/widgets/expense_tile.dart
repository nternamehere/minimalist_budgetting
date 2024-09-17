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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
              onPressed: onEditPressed,
              icon: Icons.edit,
              backgroundColor: Colors.green[200]!,
              borderRadius: BorderRadius.circular(4)),
          SlidableAction(
              onPressed: onDeletePressed,
              icon: Icons.delete,
              backgroundColor: Colors.grey[800]!,
              borderRadius: BorderRadius.circular(4)),
        ]),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
          child: ListTile(title: Text(title), trailing: Text(value)),
        ),
      ),
    );
  }
}
