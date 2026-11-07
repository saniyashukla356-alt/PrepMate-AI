
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResumeAnalyzerScreen extends StatefulWidget {
  const ResumeAnalyzerScreen({super.key});

  @override
  State<ResumeAnalyzerScreen> createState() => _ResumeAnalyzerScreenState();
}

class _ResumeAnalyzerScreenState extends State<ResumeAnalyzerScreen> {
  PlatformFile? selectedFile;
  List<int>? selectedFileBytes;
  final TextEditingController jobDescriptionController =
      TextEditingController();

  bool isLoading = false;
  String? analysisResult;

  Future<void> pickResume() async {
    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (file == null) return;

      final bytes = await file.readAsBytes();

      if (!mounted) return;

      setState(() {
        selectedFile = file;
        selectedFileBytes = bytes;
        analysisResult = null;
      });
    } catch (error) {
      if (!mounted) return;
      showMessage('Unable to select the file. Please try again.');
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> analyzeResume() async {
    if (selectedFile == null || selectedFileBytes == null) {
      showMessage('Please upload your resume first.');
      return;
    }

    if (jobDescriptionController.text.trim().isEmpty) {
      showMessage('Please enter a job description.');
      return;
    }

    setState(() {
      isLoading = true;
      analysisResult = null;
    });

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://127.0.0.1:8000/resume/analyze'),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          selectedFileBytes!,
          filename: selectedFile!.name,
        ),
      );

      request.fields['job_description'] =
          jobDescriptionController.text.trim();

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 120),
      );

      final response = await http.Response.fromStream(streamedResponse);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (!mounted) return;

        setState(() {
          analysisResult =
              responseData['analysis']?.toString() ??
              'No analysis was returned.';
        });

        showMessage('Resume analysis completed!');
      } else {
        throw Exception(
          responseData['detail'] ?? 'Resume analysis failed.',
        );
      }
    } catch (error) {
      if (!mounted) return;
      showMessage('Analysis failed: $error');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    jobDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9FE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9FE),
        elevation: 0,
        title: const Text(
          'AI Resume Analyzer',
          style: TextStyle(
            color: Color(0xFF49316F),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF7651B5),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 750),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF8060C5),
                        Color(0xFFB29AE9),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.description_rounded,
                        color: Colors.white,
                        size: 35,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Make Your Resume Stand Out!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Upload your resume and let AI discover ways to improve your career profile.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Upload Your Resume',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF302447),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Select your resume in PDF format.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 17),
                GestureDetector(
                  onTap: isLoading ? null : pickResume,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 30,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0E9FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFB69BE8),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(17),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: const Icon(
                            Icons.cloud_upload_rounded,
                            color: Color(0xFF7952BB),
                            size: 35,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          selectedFile == null
                              ? 'Choose your resume'
                              : 'Resume selected',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF49316F),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          selectedFile?.name ??
                              'Tap here to upload a PDF file',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'PDF files only',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF7952BB),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Job Description',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF302447),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Paste the job description you want your resume to be evaluated against.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: jobDescriptionController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Enter the job description here...',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFFD8C9F1),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFFD8C9F1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFF7651B5),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 23),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : analyzeResume,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7651B5),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFB9A6D8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 23,
                            width: 23,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'Analyze My Resume',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                if (analysisResult != null) ...[
                  const SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFD8C9F1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              color: Color(0xFF7651B5),
                            ),
                            SizedBox(width: 9),
                            Expanded(
                              child: Text(
                                'Your AI Resume Analysis',
                                style: TextStyle(
                                  color: Color(0xFF49316F),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 17),
                        SelectableText(
                          analysisResult!,
                          style: const TextStyle(
                            color: Color(0xFF40364F),
                            fontSize: 14,
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 25),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE6FA),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What will you get?',
                        style: TextStyle(
                          color: Color(0xFF49316F),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 13),
                      _BenefitRow(
                        icon: Icons.score_rounded,
                        text: 'ATS compatibility score',
                      ),
                      _BenefitRow(
                        icon: Icons.lightbulb_outline_rounded,
                        text: 'Resume improvement suggestions',
                      ),
                      _BenefitRow(
                        icon: Icons.psychology_outlined,
                        text: 'Missing skills identification',
                      ),
                      _BenefitRow(
                        icon: Icons.work_outline_rounded,
                        text: 'Career improvement insights',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _BenefitRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF7651B5),
            size: 19,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF65577B),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
