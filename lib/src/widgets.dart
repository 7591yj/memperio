import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:go_router/go_router.dart';

class Header extends StatelessWidget {
  const Header(
    this.heading, {
    super.key,
    this.textStyle = const TextStyle(fontSize: 24),
  });
  final String heading;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          heading,
          style: textStyle,
        ),
      );
}

class Paragraph extends StatelessWidget {
  const Paragraph(this.content, {super.key});
  final String content;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          content,
          style: const TextStyle(fontSize: 18),
        ),
      );
}

class IconAndDetail extends StatelessWidget {
  const IconAndDetail(this.icon, this.detail, {super.key});
  final IconData icon;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(
              detail,
              style: const TextStyle(fontSize: 18),
            )
          ],
        ),
      );
}

class StyledButton extends StatelessWidget {
  const StyledButton({required this.child, required this.onPressed, super.key});
  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
        onPressed: onPressed,
        child: child,
      );
}

class StyledCircularPercentIndicator extends StatelessWidget {
  const StyledCircularPercentIndicator(
      {required this.text, required this.percent, super.key});
  final String text;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircularPercentIndicator(
        radius: 80,
        lineWidth: 15,
        progressColor: Colors.deepPurple,
        percent: percent,
        circularStrokeCap: CircularStrokeCap.round,
        center: Text(
          text,
          style: const TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class LearnCategoryButton extends StatelessWidget {
  const LearnCategoryButton({
    super.key,
    required this.text,
    required this.icon,
    required this.route,
  });

  final String text;
  final IconData icon;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          context.push('/learn/$route');
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 48,
              ),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}

class StyledContainer extends StatelessWidget {
  const StyledContainer({
    super.key,
    required this.title,
    required this.titleIcon,
    required this.route,
    required this.content,
  });

  final String title;
  final IconData titleIcon;
  final String route;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          titleIcon,
                          color: Colors.deepPurple,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    StyledButton(
                      child: const Text('더보기'),
                      onPressed: () {
                        context.push(route);
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              content,
            ],
          ),
        ),
      ),
    );
  }
}
