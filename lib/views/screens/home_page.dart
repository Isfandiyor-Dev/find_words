import 'package:find_words/controllers/questions_controller.dart';
import 'package:find_words/models/question.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final QuestionsController controller = Get.put(QuestionsController());

  late List<Map<String, dynamic>> selectedVariants;
  late List<String> variants;

  @override
  void initState() {
    super.initState();
    variants = controller.getVariants();
    selectedVariants = controller.selectedVariants;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(0, -0.88),
              child: Container(
                width: 80,
                height: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: GetBuilder<QuestionsController>(builder: (context) {
                  return Text(
                    (controller.currentQuestionIndex + 1).toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
              ),
            ),
            Align(
              alignment: const Alignment(0, -0.4),
              child: SizedBox(
                width: 400,
                height: 300,
                child: Center(
                  child: GetBuilder<QuestionsController>(builder: (context) {
                    return Text(
                      controller
                          .questionsList[controller.currentQuestionIndex].text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                ),
              ),
            ),
            Positioned(
              right: 15,
              bottom: MediaQuery.of(context).size.height * 0.45,
              child: IconButton(
                onPressed: () {
                  controller.removeLastSelectedVariants();
                },
                icon: const Icon(
                  Icons.backspace_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).size.height * 0.32,
              child: GetBuilder<QuestionsController>(builder: (controller) {
                Question question =
                    controller.questionsList[controller.currentQuestionIndex];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(question.answer.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.lightBlue[900]!,
                              width: 3,
                            ),
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              selectedVariants.length > index
                                  ? selectedVariants[index]['letter']
                                  : "",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).size.height * 0.15,
              child: GetBuilder<QuestionsController>(builder: (context) {
                return Center(
                  child: Wrap(
                    spacing: 6.0,
                    runSpacing: 6.0,
                    children: List.generate(variants.length, (index) {
                      bool isSelect = selectedVariants
                              .any((element) => element["index"] == index) ||
                          selectedVariants.length >=
                              controller
                                  .questionsList[
                                      controller.currentQuestionIndex]
                                  .answer
                                  .length;
                      return InkWell(
                        onTap: isSelect
                            ? null
                            : () {
                                controller.addSlectedVariants(
                                    index: index, letter: variants[index]);
                              },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color:
                                isSelect ? Colors.grey : Colors.lightBlue[900],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              variants[index],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),
            Positioned(
              left: 25,
              right: 25,
              bottom: 30,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  fixedSize: const Size(double.infinity, 60),
                  backgroundColor: const Color.fromARGB(255, 185, 97, 210),
                ),
                onPressed: () {
                  // ignore: unrelated_type_equality_checks
                  bool isWin =
                      selectedVariants.map((e) => e["letter"]).join() ==
                          controller
                              .questionsList[controller.currentQuestionIndex]
                              .answer
                              .toLowerCase();
                  Get.defaultDialog(
                      contentPadding: const EdgeInsets.only(
                        left: 30,
                        right: 30,
                        bottom: 30,
                      ),
                      title: isWin ? "Siz Yutdingiz!" : "Siz yutqazdingiz!",
                      titlePadding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 20,
                      ),
                      middleText: isWin
                          ? "Siz javobni to'g'ri topdingiz keygi savolni javobini topishga urinib ko'rasizmi?"
                          : "Sizning javobingiz noto'g'ri, qayta urinib ko'rasizmi?",
                      textCancel: 'Qayta urinish',
                      textConfirm: controller.questionsList.length >
                              controller.currentQuestionIndex + 1
                          ? 'Keyingi'
                          : "Qaytadan",
                      onCancel: () {
                        controller.clearSelectedVariants();
                        variants = controller.getVariants();
                        Get.back();
                      },
                      onConfirm: () {
                        if (controller.questionsList.length >
                            controller.currentQuestionIndex + 1) {
                          controller.nextQuestion();
                          variants = controller.getVariants();
                        } else {
                          controller.restartGame();
                          variants = controller.getVariants();
                        }
                        Get.back();
                      });
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
