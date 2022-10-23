import 'package:flutter/material.dart';
import 'package:novelai_manager/prompt/converter/prompt_converter.dart';

/// プロンプトを変換機能を使うダイアログ
/// NAI → WebUIとWebUI → NAIの選択肢が表示され
/// 選択した方のプロンプトが返される
class PromptConvertDialog extends StatelessWidget {
  //変換元のプロンプト
  final String prompt;

  const PromptConvertDialog({super.key, required this.prompt});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("プロンプトを変換してコピー"),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 8, 8),
          child: SizedBox(
            width: 256,
            child: Text(
              prompt,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            //NovelAIのプロンプトをパースする
            final parsePrompt = PromptConverter.parseNAIPrompt(prompt);
            //パースしたデータを使ってWebUI用のプロンプトにエンコード
            final webUIPrompt =
                PromptConverter.encodeToWebUIPrompt(parsePrompt);
            Navigator.pop(context, webUIPrompt);
          },
          child: Text(
            "NovelAI → WebUI",
            style:
                Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 24),
          ),
        ),
        const SizedBox(height: 4),
        SimpleDialogOption(
          onPressed: () {
            //WebUIのプロンプトをパースする
            final parsePrompt = PromptConverter.parseWebUIPrompt(prompt);
            //パースしたデータを使ってNovelAI用のプロンプトにエンコード
            final novelAIPrompt =
                PromptConverter.encodeToNAIPrompt(parsePrompt);
            Navigator.pop(context, novelAIPrompt);
          },
          child: Text(
            "WebUI → NovelAI",
            style:
                Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 24),
          ),
        ),
      ],
    );
  }
}
